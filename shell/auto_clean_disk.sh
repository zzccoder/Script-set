#!/bin/bash
#auto clean disk space
##################

rm -rf /boot/test.img
find /boot/ -name "*.log" -size +100M -exec rm -rf {} \；