#!/usr/bin/env bash


cd build
rm -rf *
cmake  ..
make -j8
cd ..




