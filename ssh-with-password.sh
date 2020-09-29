#!/bin/sh
/usr/bin/ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no $@
