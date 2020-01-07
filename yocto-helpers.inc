findbb() {
  find -name "*.bb" -o -name "*.bbappend" -o -name "*.bbclass"
}

grepbb() {
  grep --color=always -Hn "$1" `findbb`
}
