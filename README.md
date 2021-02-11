# T-REX
T-REX - Terminal Rpn calculator EXperiment

This is a Reverse Polish Notation calculator similar to the traditional calculators from Hewlett Packard. See https://www.hpmuseum.org/rpn.htm for info on RPN.

This software runs in a terminal emulator and requires Ruby to be installed.  It is tested only on Linux so far.

The stack is shown to the top left: L is the "Last X" register showing the previous value in X. T, Z, Y and X registers comprise the operating stack. Toggle US and European number formats by pressing '. 

Functions available are shown under the stack registers. The orange symbol corresponds to the key to be pressed. For functions above each label (grey functions), press the Control key (Ctrl) and the orange key (asin = Ctrl+i).

For Rectangular to Polar conversions:
```
R-P: X value in x, Y in y - yields "θ" in y and "r" in x.
P-R: "θ" in y and "r" in x - yeilds X in x and Y in y.
```

Use the "f" key to set the fixed number of decimal places.

Use the "s" key to set the limit for viewing numbers in the "scientific" notation (e.g. 5e+06 for 5000000).

Content of registers #0-#9 are shown below the functions.

Store/recall using capital "S"/"R". "M" clears the regs.

You can undo all the way to the beginning of the session.

The stack, register contents and modes are saved on Quit.
 
Alternative keys: Left/Right keys (in addition to "<") exchanges X and Y
registers. Backspace clears the x register.

## Copy/Paste to/from X
You can paste numbers directly to the x register the normal way (middle mouse
button or Shift+Insert). You can copy/yank the number in the x register by
pressing "y" to paste in into other applications (needs "xclip" installed).

## Screencast

[![T-REX screencast](/img/screenshot.png)](https://youtu.be/vhSFH1j-vEY)
