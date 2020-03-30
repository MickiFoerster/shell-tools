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

