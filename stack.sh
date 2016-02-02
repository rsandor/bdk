#!/bin/bash

source "$BDK_ROOT/commands.sh"

# Creates a file based stack for use in a script
# @param $1 <name> Name of the stack to create
stack() {
  local name="$1"
  local filename=".${name}.bdk.stack"
  $_touch $filename
  eval "
    ${name}.push() { stack::push '${filename}' "\$1"; }
    ${name}.pop() { stack::pop '${filename}'; }
    ${name}.top() { stack::top '${filename}'; }
    ${name}.set() { stack::set '${filename}' "\$1"; }
    ${name}.clear() { stack::clear '${filename}'; }
    ${name}.destroy() { stack::destroy '${name}' '${filename}'; }
  "
}

# Pushes an element onto the stack
# @param $1 <filename> Filename for the stack
# @param $2 <value> Value to push onto the stack
stack::push() {
  local filename="$1"
  local value="$2"
  echo $value
  $_echo "$value" >> "$filename"
}

# Pops an element off the stack
# @param $1 <filename> Filename for the stack
stack::pop() {
  local filename="$1"
  local contents=$($_sed \$d "$filename")
  $_echo "$contents" > "$filename"
}

# Echos the top element of the stack
# @param $1 <filename> Filename for the stack
stack::top() {
  local filename="$1"
  $_tail -n 1 "$filename"
}

# Sets the top element of the stack
# @param $1 <filename> Filename for the stack
# @param $2 <value> Value to push onto the stack
stack::set() {
  local filename="$1"
  local value="$2"
  stack::pop "$filename"
  $_echo "$value" >> "$filename"
}

# Removes all elements from the stack
# @param $1 <filename> Filename for the stack
stack::clear() {
  local filename="$1"
  $_rm -f "$filename"
  $_touch "$filename"
}

# Removes the stack entirely
# @param $1 <name> Name of the stack
# @param $2 <filename> Filename for the stack
stack::destroy() {
  local name="$1"
  local filename="$2"
  $_rm -f "$filename"
  eval "
    unset -f ${name}.push
    unset -f ${name}.pop
    unset -f ${name}.top
    unset -f ${name}.set
    unset -f ${name}.clear
    unset -f ${name}.destroy
  "
}
