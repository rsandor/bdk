#!/bin/bash

source "$BDK_ROOT/commands.sh"

# Creates a file based hashtable for use in a script
# @param $1 <name> Name for the hashtable.
hashtable() {
  local name="$1"
  local filename=".${name}.bdk.hashtable"
  $_touch "$filename"
  eval "
    ${name}.set() { hashtable::set '${filename}' \"\$1\" \"\$2\"; }
    ${name}.get() { hashtable::get '${filename}' \"\$1\"; }
    ${name}.delete() { hashtable::delete '${filename}' \"\$1\"; }
    ${name}.clear() { hashtable::clear '${filename}'; }
    ${name}.destroy() { hashtable::destroy '${name}' '${filename}'; }
  "
}

# Removes a hashtable entirely
# @param $1 <name> Name of the hashtable
# @param $2 <filename> Filename for the hashtable
hashtable::destroy() {
  local name="$1"
  local filename="$2"
  $_rm -f "$filename"
  eval "
    unset -f ${name}.set
    unset -f ${name}.get
    unset -f ${name}.delete
    unset -f ${name}.clear
    unset -f ${name}.destroy
  "
}

# Sets a value in the hashtable
# @param $1 <filename> Filename for hashtable
# @param $2 <key> Key to set
# @param $3 <value> Value to set
hashtable::set() {
  local filename="$1"
  local key="$2"
  local value="$3"
  local contents=$($_sed -n "/^{$key}=/!p" "$filename")
  $_echo "$contents" > "$filename"
  $_echo "{$key}=$value" >> "$filename"
}

# Echos a value in the hashtable
# @param $1 <filename> Filename for hashtable
# @param $2 <key> Key to set
hashtable::get() {
  local filename="$1"
  local key="$2"
  $_grep "{$key}=" "$filename" | $_cut -d '=' -f 2
}

# Deletes a key from the hashtable
# @param $1 <filename> Filename for hashtable
# @param $2 <key> Key to set
hashtable::delete() {
  local filename="$1"
  local key="$2"
  local contents=$($_sed -n "/^{$key}=/!p" "$filename")
  $_echo "$contents" > "$filename"
}

# Deletes all keys from the hashtable
# @param $1 <filename> Filename for hashtable
hashtable::clear() {
  local filename="$1"
  $_echo '' > "$filename"
}
