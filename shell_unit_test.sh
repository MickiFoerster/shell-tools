#!/bin/bash

init() {
}

cleanup() {
}

ok() {
  printf "%-76s \e[1;32m[OK]\e[0;0m\n" "$1"
}

fail() {
  printf "%-74s \e[1;31m[FAIL]\e[0;0m\n" "$1"
}

expect_to_fail() {
  if [ $? -ne 0 ];then 
    ok "$1"
  else
    fail "$1"
  fi
}

expect_to_succeed() {
  if [ $? -eq 0 ];then 
    ok "$1"
  else
    fail "$1"
  fi
}

test1() {
  echo "your test commands here ..."
  # check error code 0 or >0
  expect_to_fail "first test"
}
test2() {
  echo "your test commands here ..."
  # check error code 0 or >0
  expect_to_succeed "second test"
}

test1
test2
