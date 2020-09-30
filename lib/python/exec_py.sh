#!/usr/bin/env bash
export PYTHON3_HOME=/home/hopson/apps/usr/webserver/python3.6.0
export LD_LIBRARY_PATH=$PYTHON3_HOME/lib



if [ $# != 0 ] ; then
$PYTHON3_HOME/bin/python3 $1 $2 $3 $4 $5 $6 $7 $8 $9
else
$PYTHON3_HOME/bin/python3
fi
#$PYTHON3_HOME/bin/python3 $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 

