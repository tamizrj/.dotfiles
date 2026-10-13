# add path stuff to conf.d!!
if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g fish_transient_prompt 1
    set -gx SHELL (which fish)
    set -gx EDITOR nvim
end

