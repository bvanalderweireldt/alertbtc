#!/bin/bash

if [ $# -ge 0 ] && [ $# -le 2 ]; then
    echo 'Wrong number of arguments, $1 -> target price, $2 from email, $3 dest email'
    exit 2
fi

CURL=$(which curl)
GREP=$(which grep)
AWK=$(which awk)
CUT=$(which cut)

LAST_PRICE=$($CURL -s http://api.bitcoincharts.com/v1/weighted_prices.json | $GREP -Po '{"USD":[^}]*}' | $GREP -Po '24h":\s"\d+\.\d+' | $AWK '{print $2}' | $CUT -c 2- | $GREP -Po '^\d+')

if [ "$LAST_PRICE" -gt $1 ]; then
	echo "Bitcoin price just reached $1" | mail -s "Alert BTC reach $1" -r $2 $3
fi