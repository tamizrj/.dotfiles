function mygpp --wraps='g++ -std=c++23 -Wall -Wextra -fsanitize=address,undefined -g' --description 'C++ compile command for CP'
    g++ -std=c++23 -Wall -Wextra -fsanitize=address,undefined -g $argv
end
