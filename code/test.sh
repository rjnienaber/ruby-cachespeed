#!/bin/sh

rm -f results.csv
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 1 -d 10; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 10 -d 10; done
