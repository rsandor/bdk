#!/bin/bash

# Common commands needed by various BDK libraries. Commands are used via a
# direct path in case the user has stubbed or overridden the default commands
# in any way
export _echo=$(which echo)
export _grep=$(which grep)
export _sed=$(which sed)
export _cut=$(which cut)
export _touch=$(which touch)
export _rm=$(which rm)
export _tail=$(which tail)
