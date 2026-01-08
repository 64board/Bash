#!/bin/bash
# TMUX Helper.
# janeiros@mbfcc.com
# 2024-08-25

# For help see https://www.man7.org/linux/man-pages/man1/tmux.1.html

usage() { echo "Usage: $(basename $0) [-l|-s <session_name>|-r <session_name>|-h]" 2>&1; exit 1; }

while getopts "s:r:|lh" o;
do
    case "${o}" in
        l)
            # List tmux existing sessions.

            tmux ls
            ;;
        s)
            # Attach to an existing session or creates a new one.

            SESSION=${OPTARG}

            tmux has -t ${SESSION} 2> /dev/null

            if [ $? != 0 ]
            then
                # Lock after time in seconds; 0 = never.
                tmux new -d -s ${SESSION} \; set -g mouse on \; set -g lock-command vlock \; set -g lock-after-time 0 \; bind l lock-client \; bind L lock-session \; attach
            else
                tmux a -t ${SESSION}
            fi

            ;;
        r)
            # Attach to a session in read-only mode.

            SESSION=${OPTARG}

            tmux has -t ${SESSION} 2> /dev/null

            if [ $? != 0 ]
            then
                echo "Session ${SESSION} was not found!"
            else
                tmux a -r -t ${SESSION}
            fi

            ;;
        *)
            # Show help for the case of any option different than l, s and r.
            usage
            ;;
    esac
done

# The case of arguments without option or no option at all.
# OPTIND is initialized to 1 and points to the next argument after getopts finishes.
# A value different than 1 here means the while loop was never entered.
[ ! "${OPTIND}" = "1" ]  || usage

##END##
