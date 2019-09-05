#!/bin/bash
BIN_DIR=$(dirname "$(readlink -f "$0")")

_update() {
  # $1: URL of file
  # $2: File name of command
  curl $1 -o $BIN_DIR/$2 && chmod +x $BIN_DIR/$2
}

_update_github() {
  # $1: Repository string on Github
  # $2: Path of file in Git repository
  # $3: File name of command
  test -z "$2" && branch="master" || branch=$2
  test -z "$3" && git_path=${1##*/} || git_path=$3
  test -z "$4" && file_name=${git_path##*/} || file_name=$4
  _update https://raw.githubusercontent.com/$1/$branch/$git_path $file_name
}

_run() {
  is_first_file=true
  while IFS=, read -r repo branch git_path file_name
  do
    if $is_first_file; then
      is_first_file=false
      continue
    fi
    _update_github "$repo" "$branch" "$git_path" "$file_name"
  done < $BIN_DIR/data.csv
}

_run
