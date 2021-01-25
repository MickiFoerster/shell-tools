cdbb() {
    if [ -z "$1" ]; then
      echo "Argument missing"
      return 1
    fi
    bb=$(findbb |  grep $1 | head -n1)
    if [ -z "${bb}" ]; then
      echo "Cannot find '$1'"
      return 2
    fi
    target_dir=$(dirname ${bb})
    if [ ! -d "${target_dir}" ]; then
      echo "Cannot find directory of '$bb'"
      return 3
    fi
    cd ${target_dir}
    if [ $? -ne 0 ]; then
      echo "Cannot change directory to ${target_dir}"
      return 4
    fi
    return 0
}

findservice() {
  find -name "*.service"
}

findbb() {
  find -name "*.bb" -o -name "*.bbappend" -o -name "*.bbclass"
}

grepbb() {
  grep --color=always -Hn "$1" `findbb`
}

vimbb() {
    if [ -z "$1" ]; then
      echo "error: give recipe to edit as parameter"
      return 1
    fi
    res=`findbb | grep $1 | head -n1 `
    if [ -n "$res" ]; then
      vim $res
    else
      echo "vimbb: no matches found"
    fi
}

vimbbclass() {
    if [ -z "$1" ]; then
      echo "error: give recipe to edit as parameter"
      return 1
    fi
    res=`findbb | grep $1 | head -n1 `
    if [ -n "$res" ]; then
      cd $(dirname "$res") 
      ctags --languages=python,sh $(basename "$res")
      vim $(basename "$res")
      cd -
    else
      echo "vimbb: no matches found"
    fi
}

export BB_NUMBER_THREADS="3"
export PARALLEL_MAKE="-j3"
