#!/bin/sh

rm results.csv
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 1 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 2 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 3 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 4 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 5 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 6 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 7 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 8 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 9 -d 600; done
for f in memcache redis mysql postgresql; do echo; ruby benchmark.rb -b $f -t 10 -d 600; done
