# Runs in a background fish. Computes the git segment for the directory it was
# launched in and writes "seq\ncwd\nsegment" to $__crp_file, then signals the
# parent shell. See custom_right_prompt.fish for the protocol.
function __custom_right_prompt_async
    set -l file $__crp_file
    set -l tmp $file.tmp.$fish_pid
    set -l vcs (__custom_right_prompt_git)
    printf '%s\n%s\n%s' "$__crp_seq" "$PWD" "$vcs" > $tmp
    command mv -f $tmp $file
    command kill -USR1 $__crp_pid 2>/dev/null
end
