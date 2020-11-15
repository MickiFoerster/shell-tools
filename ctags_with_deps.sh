#!/bin/sh

# Found here: https://vim.fandom.com/wiki/Generate_ctags_file_for_a_C/C%2B%2B_source_file_with_all_of_their_dependencies_(standard_headers,_etc)

gcc -M $* 2>/dev/null | sed -e 's/[\\ ]/\n/g' | \
    sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | ctags -L - --c++-kinds=+p --fields=+iaS --extra=+q
