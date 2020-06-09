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
