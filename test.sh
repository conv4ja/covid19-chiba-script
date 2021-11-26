#!/bin/sh -e

PATH=$PWD:$PATH

conv.py fixture/0725kansensya.xlsx
fix.sh
shellspec
