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
basefilename=`basename $1 .tex`
logfilename=${basefilename}.log
pytxcodefilename=${basefilename}.pytxcode
echo "Log file: " ${logfilename}
echo "Working directory: " `pwd`
echo "Using latex command: " ${latexcommand}
echo "Using pythontex command: " ${pythontexcommand}

# compile using latex
echo -e "\n\npythontex-wrapper: Calling ${latexcommand}"
echo -e "------------------------------------------\n\n"
${latexcommand} $@
lastResult=$?
echo "First latex run: ${lastResult}" >> pythontex-wrapper.log
if [ $lastResult -gt 0 ] ; then
    # compilation using latex failed
    echo "pythontex-wrapper: This was the first latex run, before pythontex was called!" >> ${logfilename}
    echo "pythontex-wrapper: pythontex may have been run previously by lyx, before bibtex was run." >> ${logfilename}
    echo "pythontex-wrapper: If the problem was due to bad python output and persists after fixing it,"  >> ${logfilename}
    echo "pythontex-wrapper: please delete the pythontex-file-${basefilename} folder in the output directory." >> ${logfilename}
    exit 1
fi

# compilation in latex worked, run pythontex3 if needed
if [ ! -e ${pytxcodefilename} ] ; then
    echo "pythontex-wrapper: No pytxcode file generated, no need to run pythontex!" | tee -a ${logfilename}
    exit 0
fi

echo -e "\n\npythontex-wrapper: Calling ${pythontexcommand}"
echo -e "------------------------------------------\n\n"
${pythontexcommand} $1
lastResult=$?
echo "pythontex run: ${lastResult}" >> pythontex-wrapper.log
if [ ${lastResult} -gt 0 ]; then
    # running pythontex failed
    # lyx expects LaTeX error messages in the log file
    # Add a fake latex error message which lyx understands
    echo "! Undefined control sequence." >>${logfilename}
    echo "l.17 \\pythontexError" >>${logfilename}
    echo "\\Actually there is a pythontex error, see complete log for details." >>${logfilename}
    
    exit 1
fi

# pythontex worked, run latex again
echo -e "\n\npythontex-wrapper: Calling ${latexcommand}"
echo -e "------------------------------------------\n\n"
${latexcommand} $@
lastResult=$?
echo "Second latex run: ${lastResult}" >> pythontex-wrapper.log
echo "pythontex-wrapper: This was the second latex run, after pythontex was called!" >> ${logfilename}
if [ ${lastResult} -gt 0 ] ; then
    # compilation using latex failed
    exit 1
fi

# compilation in latex worked
exit 0
