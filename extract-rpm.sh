#!/bin/sh
rpm2cpio $1 | cpio -imdv
