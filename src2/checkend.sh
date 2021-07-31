#!/bin/bash
#

IP='python_populator'
ping -c 10 $IP 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "Python Populator Not Ready Yet" >> /tmp/pp.log
else
  /usr/local/bin/python3 /tmp/consultatorDB.py
fi