#!/usr/bin/env bash
# ==============================================================================
# MODULAR BASH NAVIGATOR  —  (z + starship) But shitty and less* dependencies
# Architecture: strict MVC — Model returns raw data, View handles all ANSI,
# Controller orchestrates. Plugins are interchangeable environment detectors.
# ==============================================================================


# ==============================================================================
# [CONFIG]  Global constants & environment
# ==============================================================================

export NAV_DB="${NAV_DB:-$HOME/.config/zship_db}"
export NAV_DECAY="${NAV_DECAY:-0.9}"

mkdir -p "$(dirname "$NAV_DB")"
touch "$NAV_DB"

_Z_LAST_PWD=""


# ==============================================================================
# [VIEW]  UI primitives — the only layer that touches ANSI escape codes
# ==============================================================================

# Named color constants (keep all raw codes here and nowhere else)
readonly _C_RESET='\[\e[0m\]'
readonly _C_RED='\[\e[31m\]'
readonly _C_GREEN='\[\e[32m\]'
readonly _C_YELLOW='\[\e[33m\]'
readonly _C_CYAN='\[\e[36m\]'

# _ui_color <name>
# Emits a named ANSI color escape.
_ui_color() {
    case "$1" in
        red)    printf '%s' "$_C_RED"    ;;
        green)  printf '%s' "$_C_GREEN"  ;;
        yellow) printf '%s' "$_C_YELLOW" ;;
        cyan)   printf '%s' "$_C_CYAN"   ;;
        reset)  printf '%s' "$_C_RESET"  ;;
    esac
}

# _ui_wrap <color> <text>
# Wraps text in the given named color, always resetting afterward.
# Returns empty string when text is empty (avoids orphan escape codes).
_ui_wrap() {
    local color="$1" text="$2"
    [[ -z "$text" ]] && return
    printf '%s%s%s' "$(_ui_color "$color")" "$text" "$(_ui_color reset)"
}

# _ui_segment <color> <text>
# Like _ui_wrap but prefixes a space — used to append optional prompt segments.
_ui_segment() {
    local color="$1" text="$2"
    [[ -z "$text" ]] && return
    printf ' %s%s%s' "$(_ui_color "$color")" "$text" "$(_ui_color reset)"
}

# _get_path_info
# VIEW: Formats the current directory. Git-repo-aware (shows repo/relative form).
_get_path_info() {
    local display
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local root base
        root=$(git rev-parse --show-toplevel)
        base=$(basename "$root")
        if [[ "$PWD" == "$root" ]]; then
            display="$base"
        else
            display="${base}/${PWD#"$root"/}"
        fi
    else
        display="${PWD/#$HOME/\~}"
    fi
    _ui_wrap cyan "$display"
}


# ==============================================================================
# [MODEL]  Data layer — pure detection, no ANSI, no side-effects
# ==============================================================================

# _nav_db_sync
# MODEL: Applies time-decay to all scores and upserts the current directory.
_nav_db_sync() {
    local tmp now found=0
    tmp=$(mktemp)
    now=$(date +%s)

    while IFS='|' read -r path score ts; do
        [[ -z "$path" || -z "$score" ]] && continue
        local age=$(( now - ts ))
        local decayed
        decayed=$(awk -v s="$score" -v a="$age" -v f="$NAV_DECAY" \
            'BEGIN { print int(s * (f ^ (a / 86400))) }')
        if [[ "$path" == "$PWD" ]]; then
            printf '%s|%s|%s\n' "$path" "$(( decayed + 1 ))" "$now" >> "$tmp"
            found=1
        else
            printf '%s|%s|%s\n' "$path" "$decayed" "$ts" >> "$tmp"
        fi
    done < "$NAV_DB"

    (( found == 0 )) && printf '%s|1|%s\n' "$PWD" "$now" >> "$tmp"
    mv "$tmp" "$NAV_DB"
}

# _nav_search <pattern>
# MODEL: Returns pipe-delimited DB rows matching pattern, sorted by priority
# then score (descending). Priority tiers (lower = better):
#   1 — basename exactly equals pattern
#   2 — basename starts with pattern   (e.g. "dev" → "Developer")
#   3 — basename contains pattern      (e.g. "ux"  → "linux")
#   4 — full path contains pattern     (e.g. "src" → "/home/matt/proj/src/foo")
# Score only breaks ties within the same tier — a high-score directory in tier 3
# will never beat a low-score directory in tier 2.
_nav_search() {
    local pattern="$1"
    [[ -z "$pattern" ]] && return
 
    awk -v pat="$pattern" -F'|' '
        BEGIN { IGNORECASE = 1 }
        {
            n = split($1, parts, "/")
            basename = parts[n]
            lo_base = tolower(basename)
            lo_pat  = tolower(pat)
            if      (lo_base == lo_pat)                  print 1 "|" $0
            else if (index(lo_base, lo_pat) == 1)        print 2 "|" $0
            else if (index(lo_base, lo_pat) >  0)        print 3 "|" $0
            else if (index(tolower($1), lo_pat) >  0)    print 4 "|" $0
        }
    ' "$NAV_DB" \
        | sort -t'|' -k1,1n -k3,3rn \
        | cut -d'|' -f2-
}

# _get_git_info
# MODEL: Returns a plain string like " main+!" or " dev ↑" — no ANSI.
# Empty output = not a git repo.
_get_git_info() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local branch markers="" remote="" ahead behind counts
    branch=$(git symbolic-ref --short HEAD 2>/dev/null \
             || git rev-parse --short HEAD 2>/dev/null)
    local status
    status=$(git status --porcelain 2>/dev/null)

    grep -q '^[ACDMRT]'  <<< "$status" && markers+='+'   # staged
    grep -q '^[ MTd]'    <<< "$status" && markers+='!'   # modified
    grep -q '??'         <<< "$status" && markers+='?'   # untracked

    counts=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    if [[ -n "$counts" ]]; then
        read -r ahead behind <<< "$counts"
        (( ahead > 0 && behind > 0 )) && remote="↕" \
            || (( ahead  > 0 )) && remote="↑" \
            || (( behind > 0 )) && remote="↓"
    fi

    printf ' %s %s%s' " $branch" "$remote" "$markers"
}

# _get_git_color <raw_git_info>
# MODEL: Derives the semantic color name for the git segment.
_get_git_color() {
    local info="$1"
    if   [[ "$info" =~ [+!?] ]]; then echo "red"
    elif [[ "$info" =~ [↑↓↕] ]]; then echo "yellow"
    else echo "green"
    fi
}

# _get_lang_info
# MODEL: Returns a plain string like "🐍 3.11.2" for the first matching language.
# Empty output = no recognised language files in CWD.
_get_lang_info() {
    declare -A LANG_MAP=(
        [py]="🐍:python --version"
        [js]="🟨:node --version"
        [ts]="🟦:tsc --version"
        [rb]="💎:ruby -v"
        [go]="🐹:go version"
        [rs]="🦀:rustc --version"
    )
    local ext
    for ext in "${!LANG_MAP[@]}"; do
        ls *."$ext" >/dev/null 2>&1 || continue
        local entry emoji cmd version
        entry="${LANG_MAP[$ext]}"
        emoji="${entry%%:*}"
        cmd="${entry##*:}"
        version=$($cmd 2>/dev/null \
                  | head -n1 \
                  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
                  | head -n1)
        printf '%s %s' "$emoji" "$version"
        return
    done
}


# ==============================================================================
# [CONTROLLER]  Navigation entry-point and prompt orchestration
# ==============================================================================

# _nav_jump <target> [silent=0]
# CONTROLLER: Changes directory and syncs the DB; prints destination unless silent.
_nav_jump() {
    local target="$1" silent="${2:-0}"
    if [[ -d "$target" ]]; then
        cd "$target" || return 1
        (( silent == 0 )) && echo "z: $PWD"
        _nav_db_sync
    else
        echo "z: directory no longer exists: $target" >&2
        return 1
    fi
}

# z [<pattern>|-l <pattern>]
# CONTROLLER: Public entry-point for frecency-based navigation.
#   z            — go home
#   z <path>     — go to a literal path
#   z <pattern>  — jump to the highest-scoring frecency match
#   z -l <pat>   — list matches without jumping
z() {
    local list_only=0
    [[ "$1" == "-l" ]] && { list_only=1; shift; }
    local pattern="$1"

    # Rule 1: no pattern → go home
    if [[ -z "$pattern" ]]; then
        _nav_jump "$HOME" 1
        return
    fi

    # Rule 2: real path on disk → jump directly
    if [[ -d "$pattern" && $list_only -eq 0 ]]; then
        _nav_jump "$pattern" 1
        return
    fi

    # Rule 3: frecency search
    local matches
    matches=$(_nav_search "$pattern")

    if [[ -z "$matches" ]]; then
        echo "z: no match found for '$pattern'" >&2
        return 1
    fi

    # List mode
    if (( list_only == 1 )); then
        awk -F'|' '{printf "%-6s %s\n", $2, $1}' <<< "$matches"
        return
    fi

    # Jump to top result; surface count when alternatives exist
    local top_match match_count
    top_match=$(head -n1 <<< "$matches" | cut -d'|' -f1)
    match_count=$(wc -l <<< "$matches")
    (( match_count > 1 )) && echo "z: ${match_count} matches. Jumping to: $top_match"

    _nav_jump "$top_match"
}

# _render_prompt
# CONTROLLER: Orchestrates Model → View pipeline and assembles PS1.
# Assigned to PROMPT_COMMAND — runs before every prompt draw.
_render_prompt() {
    local last_exit=$?

    # Sync DB on directory change
    if [[ "$PWD" != "$_Z_LAST_PWD" ]]; then
        _nav_db_sync
        _Z_LAST_PWD="$PWD"
    fi

    # --- Model calls (raw data) ---
    local git_raw lang_raw
    git_raw=$(_get_git_info)
    lang_raw=$(_get_lang_info)

    # --- View calls (decorated segments) ---
    local path_seg git_seg lang_seg char_seg

    path_seg=$(_get_path_info)
    git_seg=$(_ui_segment "$(_get_git_color "$git_raw")" "$git_raw")
    lang_seg=$(_ui_segment "reset" "$lang_raw")

    local char_color="green"
    (( last_exit != 0 )) && char_color="red"
    char_seg="$(_ui_wrap "$char_color" "❯")"

    # --- Assembly ---
    PS1="\n${path_seg}${git_seg}${lang_seg}\n${char_seg} "
}

PROMPT_COMMAND="_render_prompt"
