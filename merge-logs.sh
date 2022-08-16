#!/usr/bin/env bash

LOGS=$(find . -name "access-log-*.csv" -type f)

echo "" > .temp

for L in $LOGS
do
  echo $L
  cat $L >> .temp
done

cat .temp | sort -k1 -t, -u -r > merged.csv
rm .temp
