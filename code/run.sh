#!/bin/sh

#check all benchmarks work
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 10 -d 1 -o warmup.csv; done
rvm jruby-1.7.19@cache_speed do ruby benchmark.rb -b infinispan -t $f -d 600 -o warmup.csv
rm -f warmup.csv

OUTPUT_FILE=results_all.csv
rm -f $OUTPUT_FILE

# mri
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b memcache -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b redis -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b mongo -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b postgresql -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b mysql -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b mysql_active_record -t $f -d 600 -o $OUTPUT_FILE; done
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm ruby-2.2.0@cache_speed do ruby benchmark.rb -b mysql_innodb -t $f -d 600 -o $OUTPUT_FILE; done

# jruby
for f in 1 2 3 4 5 6 7 8 9 10; do echo; rvm jruby-1.7.19@cache_speed do ruby benchmark.rb -b infinispan -t $f -d 600 -o  $OUTPUT_FILE; done
