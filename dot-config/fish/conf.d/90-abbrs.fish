# fish abbreviations and alii

# general
alias c=clear
alias v=nvim
alias so="exec fish"

# git
abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gaa git add -A
abbr -a gps git push
abbr -a gpl git pull
abbr -a gcm --set-cursor "git commit -m \"%\""
abbr -a gsw git switch
abbr -a gl git log
abbr -a gr git restore
abbr -a gd git diff

# CP
alias mygpp="g++ -std=c++23 -Wall -Wextra -fsanitize=address,undefined -g"
abbr -a --position anywhere --command ./a.out I "< input.txt"
abbr pp "pbpaste |"
abbr pi "pbpaste > input.txt"
