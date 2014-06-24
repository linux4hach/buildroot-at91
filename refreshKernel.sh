#!/bin/bash
rm -rf output/build/linux*
rm dl/linux*
echo "Deleted kernel and reinstalling"
make

