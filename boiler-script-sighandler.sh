#!/bin/bash


trap 'sigquit' QUIT
trap 'sigint' INT 
trap 'sigterm' TERM

function sigquit() { echo "sigquit"; exit 1; }
function sigint()  { echo "sigint";  exit 2; }
function sigterm() { echo "sigterm"; exit 3; }

for i in $(seq 1 60); do
    sleep 1;
done
