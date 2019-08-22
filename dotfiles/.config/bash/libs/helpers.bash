#!/usr/bin/env bash

_command_exists ()
{
  # checks for existence of a command
  # param '1: command to check'
  # example: '$ _command_exists ls && echo exists'
  type "$1" &> /dev/null ;
}

if ! type pathmunge > /dev/null 2>&1; then
  function pathmunge () {
    # about 'prevent duplicate directories in you PATH variable'
    # example 'pathmunge /path/to/dir is equivalent to PATH=/path/to/dir:$PATH'
    # example 'pathmunge /path/to/dir after is equivalent to PATH=$PATH:/path/to/dir'

    if ! [[ $PATH =~ (^|:)$1($|:) ]]; then
      if [ "$2" = "after" ] ; then
        export PATH=$PATH:$1
      else
        export PATH=$1:$PATH
      fi
    fi
  }
fi
