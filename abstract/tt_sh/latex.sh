#!/usr/bin/env bash

export TEXCONFIG=.:$TEXCONFIG

filename=$(echo $1 | awk 'substr($0,length($0))=="." {print substr($0, 0, length($0) - 1)}')
if [ "$filename" == '' ]; then
    filename=$1
fi
echo "filename=$filename"

./tt_sh/clean.sh "$filename"
latex "$config_text\input{$filename}" #initial ' ' is not allowed!
bibtex "$filename"
latex "$config_text\input{$filename}"
latex "$config_text\input{$filename}"
dvips "$filename" -o "$filename".ps
ps2pdf "$filename".ps "$filename".pdf

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Ubuntu
    evince $filename.pdf &
else 
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    open -a Preview $filename.pdf &
  fi
fi

