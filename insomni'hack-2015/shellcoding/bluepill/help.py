#!/usr/bin/python

"""Ascii to reverse hex for stack pushing"""

from binascii import hexlify

line="/thisisaveryrandomnameamirite"

n=8
words = [line[i:i+n] for i in range(0, len(line), n)]

for w in words:
    print '0x'+hexlify(w[::-1])

