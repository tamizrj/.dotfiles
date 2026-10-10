function __custom_right_prompt_git
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_use_informative_chars 1
    set -g __fish_git_prompt_char_dirtystate \U1F4a9
    set -g __fish_git_prompt_char_untrackedfiles "?"

    # The git prompt's default format is ' (%s)'.
    # We don't want the leading space.
    fish_vcs_prompt '(%s)' 2>/dev/null
end
