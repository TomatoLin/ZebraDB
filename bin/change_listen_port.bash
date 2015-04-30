#!/bin/bash

sed -i "s,9898,$1,g" deps/redis-2.8.19/redis.conf 
sed -i "s,9898,$1,g" config/zebra_config.xml 
sed -i "s,9999,$2,g" config/zebra_config.xml 
