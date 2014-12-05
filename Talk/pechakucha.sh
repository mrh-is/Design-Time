#/bin/bash

# This script courtesy of Chris Eidhof. I slightly modified it for longer delays.
# https://gist.github.com/chriseidhof/11179702

# Works from Deckset 1.2 upwards. Make sure you have a document opened.
#
# If you're using the Trial version change "Deckset" to "Deckset Trial"

osascript -e 'repeat' -e 'tell application "Deckset" to tell document 1 to set slideIndex to slideIndex + 1' -e 'delay 25' -e 'end repeat'
