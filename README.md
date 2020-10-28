pythontex-wrapper [![License: CC0-1.0](https://licensebuttons.net/l/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/)
=================

Wrapper around pdflatex to use pythontex in lyx.

## Usage

Modify an existing format converter in lyx (for example pdflatex) to use pythontex-wrapper.sh instead of pdflatex.

You can edit the *CONVERTERS SECTION* in the lyx configuration file ~/.lyx/preferences:

    #
    # CONVERTERS SECTION ##########################
    #
    
    \converter "pdflatex" "pdf2" "/home/mike/src/latex-stuff/python/lyx/pythontex-wrapper.sh $$i" "latex=pdflatex,hyperref-driver=pdftex"

This will change the pdflatex generator to use the pythontex-wrapper. If no pythontex-code is contained in your document, pythontex will not be run and you will get normal pdflatex output. I could not find a way to generate a pdflatex+pythontex format that works as expected.
