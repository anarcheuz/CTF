#!/usr/bin/python -u

import os
import ctypes
import sys
import code


inspect_flag = 0
if __name__ == '__main__':
	c = ctypes.CDLL("libc.so.6")
	c.printf("hello world!\n")
	c.printf("who are U?\n")
	name = os.sys.stdin.readline()
	c.printf("hi! " + name + "bye!\n")

if inspect_flag > 0 :
	vars = globals().copy()
	vars.update(locals())
	shell = code.InteractiveConsole(vars)
	shell.interact()

sys.exit(0)
