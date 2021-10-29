#!/bin/bash

# return 1 if global command line program installed, else 0
# example
# echo "node: $(program_is_installed node)"
function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

# display a message in red with a cross by it
# example
# echo echo_fail "No"
function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
}

# echo pass or fail
# example
# echo echo_if 1 "Passed"
# echo echo_if 0 "Failed"
function echo_if {
  if [ $1 == 1 ]; then
    echo_pass $2
  else
    echo_fail $2
  fi
}

echo "node    $(echo_if $(program_is_installed node))"
echo "npm    $(echo_if $(program_is_installed npm))"
if ([ $(program_is_installed node) == 1 ] && [ $(program_is_installed npm) == 1 ]); then
    echo -e "Node & npm installed, update (if available) will be attempted.\n"
    npm cache clean -f
    npm install -g n
    n stable
    node -v

    echo -e "\nNode update(if available) completed. Proceeding to npm update\n"
    npm -v
    npm update -g npm
    npm -v

    echo -e "\nNPM update(if available) completed."
else
    echo -e "\nNode &/ npm unavailable. Update cannot happen.\n"
fi