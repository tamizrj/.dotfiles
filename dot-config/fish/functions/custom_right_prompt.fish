# Right-side prompt segment: virtualenv, command duration, git status, time.
#
# The git part is expensive (fish's fish_vcs_prompt spawns several git
# processes), so it is computed asynchronously: the prompt renders immediately
# with the previous result and a background job refreshes it, signalling the
# shell (SIGUSR1) to repaint once it is ready.
#
# Protocol: the background job writes "seq\ncwd\nsegment" to $__crp_file and
# sends SIGUSR1. We only apply a result that matches the current directory and
# that is newer than what we have already shown.
#
# Globals:
#   __crp_file       per-shell temp file holding the latest result
#   __crp_seq        monotonically increasing job id
#   __crp_applied_seq last job id we applied
#   __crp_cache      git segment rendered by the currently shown prompt
#   __crp_cache_cwd  directory $__crp_cache belongs to
#   __crp_running    whether a background job is in flight for $__crp_running_cwd

function __custom_right_prompt_kick
    set -q __crp_running; or set -g __crp_running 0
    if test "$__crp_running" = 1; and test "$__crp_running_cwd" = "$PWD"
        return
    end

    if not set -q __crp_file
        set -l tmpdir $TMPDIR
        test -n "$tmpdir"; or set tmpdir /tmp
        set -g __crp_file (command mktemp $tmpdir/fish_custom_right_prompt.XXXXXX)
    end
    set -q __crp_seq; or set -g __crp_seq 0

    set -g __crp_running 1
    set -g __crp_running_cwd $PWD
    set -g __crp_seq (math "$__crp_seq" + 1)

    # status fish-path is the running shell binary; fall back to PATH lookup on
    # older fish versions that lack the subcommand.
    set -l fish_bin (status fish-path 2>/dev/null; or echo fish)

    set -lx __crp_file $__crp_file
    set -lx __crp_pid $fish_pid
    set -lx __crp_seq $__crp_seq
    command $fish_bin -c '__custom_right_prompt_async' &
    disown 2>/dev/null
end

function __custom_right_prompt_update --on-signal USR1
    set -q __crp_file; or return
    test -r $__crp_file; or return

    set -l seq
    set -l cwd
    set -l vcs
    set -l i 0
    while read -l line
        set i (math $i + 1)
        switch $i
            case 1
                set seq $line
            case 2
                set cwd $line
            case 3
                set vcs $line
            case '*'
                set vcs "$vcs\n$line"
        end
    end <$__crp_file

    set -q __crp_applied_seq; or set -g __crp_applied_seq 0
    test -n "$seq"; or return
    test "$seq" -gt "$__crp_applied_seq"; or return
    set -g __crp_applied_seq $seq
    set -g __crp_running 0

    if test "$cwd" = "$PWD"
        if test "$vcs" != "$__crp_cache"
            set -g __crp_cache $vcs
            set -g __crp_cache_cwd $cwd
            commandline -f repaint 2>/dev/null
        else
            set -g __crp_cache_cwd $cwd
        end
    else
        # Result for a directory we have since left; refresh for the current one.
        __custom_right_prompt_kick
    end
end

function __custom_right_prompt_cleanup --on-event fish_exit
    set -q __crp_file; or return
    command rm -f $__crp_file 2>/dev/null
end

function custom_right_prompt
    set -l d (set_color brgrey)(date "+%R")(set_color --reset)

    set -l duration
    if set -q cmd_duration
        and test "$cmd_duration" -gt 100
        set duration (math "$cmd_duration" / 1000)s
    end

    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true

    set -l venv
    if set -q VIRTUAL_ENV
        set venv (string replace -r '.*/' '' -- "$VIRTUAL_ENV")
    end

    set -l vcs
    if status is-interactive
        # Show the cached segment for this directory (empty if we don't have
        # one yet) and refresh it in the background.
        if test "$__crp_cache_cwd" = "$PWD"
            set vcs $__crp_cache
        end
        __custom_right_prompt_kick
    else
        set vcs (__custom_right_prompt_git)
    end

    string join " " -- $venv $duration $vcs $d
end
