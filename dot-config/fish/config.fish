# add path stuff to conf.d!!
set -gx EDITOR nvim-block
if status is-interactive
    # Commands to run in interactive sessions can go here
    # set -g fish_transient_prompt 1
    set -gx SHELL (which fish)
end
