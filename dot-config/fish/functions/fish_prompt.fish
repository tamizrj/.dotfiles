function fish_prompt
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end

    # Line 1: user at host in directory
    set_color yellow
    printf '%s' $USER
    set_color --reset
    printf ' at '

    set_color magenta
    echo -n (prompt_hostname)
    set_color --reset
    printf ' in '

    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color --reset

    # Right prompt (venv, duration, git status, time), aligned with line 1.
    # fish only draws a built-in right prompt on the last prompt line, so we
    # draw it ourselves: jump to the right edge of line 1 and print it there.
    set -l right (__tamiz_right_prompt)
    if test -n "$right"
        set -l right_len (string length -- (string replace -ra '\e\[[0-9;]*m' '' -- "$right"))
        if test "$right_len" -lt "$COLUMNS"
            printf '\r\e[%dG' (math "$COLUMNS" - "$right_len")
            printf '%s' "$right"
        end
    end

    # Line 2
    echo
    printf '↪ '
    set_color --reset
end
