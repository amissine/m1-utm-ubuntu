SHELL := /bin/bash # {{{1

LOCAL_MACHINE := $(shell uname -m)
TARGET := ${LOCAL_MACHINE}
MAKE_J := $(shell expr `nproc` - 1)

CC := gcc
MUSL_CC := /usr/local/musl/bin/musl-gcc

DL_CMD := curl -C - -L -o

SPACE := $(subst ,, )
