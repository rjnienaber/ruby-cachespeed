#!/bin/sh

#check all benchmarks work
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 10 -d 1 -o warmup.csv; done
rm -f warmup.csv

rm -f results_all.csv
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 1 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 2 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 3 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 4 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 5 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 6 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 7 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 8 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 9 -d 600 -o results_all.csv; done
for f in memcache redis mongo mysql mysql_innodb mysql_active_record postgresql; do echo; ruby benchmark.rb -b $f -t 10 -d 600 -o results_all.csv; done
