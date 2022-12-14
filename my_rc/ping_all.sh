#! /bin/bash
while :
do
  for i in {1..254}
  do
    ping 192.168.10.${i} -c 1 &
  done 
  sleep 10
done

