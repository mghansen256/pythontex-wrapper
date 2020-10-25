#!/bin/bash
# SPDX-License-Identifier: CC0-1.0

# Wrapper around pdflatex to use pythontex in lyx
# Author: Michael G. Hansen

# @TODO Make these configurable either via command-line or
# by changing the executable name
latexcommand="pdflatex"
pythontexcommand="pythontex3"

if [ "$1" = "--help" ] || [ "$1" = "-h" ] ; then
    echo "pythontex-wrapper V0.1, licensed CC0-1.0"
    echo "Wrapper around ${latexcommand} for use ${pythontexcommand} in lyx."
    echo "See source code for details."
    
    exit 0
fi

# print some debug information
echo "pythontex-wrapper.sh"
echo "arguments:" $@
logfilename=`basename $1 .tex`.log
echo "Log file: " ${logfilename}
echo "Working directory: " `pwd`
echo "Using latex command: " ${latexcommand}
echo "Using pythontex command: " ${pythontexcommand}

# compile using latex
if ${latexcommand} $@ ; then
    # compilation in latex worked, run pythontex3
    if ${pythontexcommand} $1 ; then
        # pythontex worked, run latex again
        if ${latexcommand} $@ ; then
            # compilation in latex worked
            exit 0
        else
            # compilation using latex failed
            exit 1
        fi
    else
        # running pythontex failed
        # lyx expects LaTeX error messages in the log file
        # Add a fake latex error message which lyx understands
        echo "! Undefined control sequence." >>${logfilename}
        echo "l.17 \\pythontexError" >>${logfilename}
        echo "\\Actually there is a pythontex error, see complete log for details." >>${logfilename}
        
        exit 1
    fi
else
    # compilation using latex failed
    exit 1
fi
