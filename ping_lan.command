#!/bin/bash

# Ping half of range and background
for ip in 10.93.0.{60..129}; do
    ping -c 1 -t 1 "$ip" > /dev/null
done &

# Ping second half concurrently
for ip in 10.93.0.{130..199}; do
    ping -c 1 -t 1 "$ip" > /dev/null
done
