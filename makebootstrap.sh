#!/bin/sh
echo '(hierarchy-traversal "disabled")' >gnetlistrc
gnetlist -L . -g makefile Makefile.sch -o Makefile
