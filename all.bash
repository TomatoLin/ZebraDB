#!/bin/bash

SNAPPY="snappy-1.1.1"
LEVELDB="leveldb-1.18"
REDIS="redis-2.8.19"

DIR=`pwd`

rm -rf deps/include deps/libs deps/${SNAPPY} deps/${LEVELDB} deps/${REDIS} || exit 1

cd deps/ && mkdir libs 

tar -zxf ${SNAPPY}.tar.gz && cd ${SNAPPY} && ./configure --disable-shared --with-pic && make || exit 1
SNAPPY_PATH=`pwd`

cp ${SNAPPY_PATH}/.libs/libsnappy.a ../libs

cd ../libs

export LIBRARY_PATH=`pwd`
export C_INCLUDE_PATH=${SNAPPY_PATH}
export CPLUS_INCLUDE_PATH=${SNAPPY_PATH}

cd ../

tar -zxf ${LEVELDB}.tar.gz && cd ${LEVELDB} &&  make || exit 1
cp libleveldb.a ../libs
mv include ../

cd ../

tar -zxf ${REDIS}.tar.gz 
cp -r redis_tmp/* ${REDIS}/
cd $REDIS

sed -i "s,ZebraDB_PATH,${DIR},g" src/Makefile 
sed -i "s,ZebraDB_PATH,${DIR}," redis.conf 

make || exit 1

cd ../../

make

mkdir var log

sed -i "s,ZebraDB_PATH,${DIR}," bin/start_zebra.sh
sed -i "s,ZebraDB_PATH,${DIR}," bin/stop_zebra.sh
sed -i "s,ZebraDB_PATH,${DIR}," config/zebra_config.xml
sed -i "s,ZebraDB_PATH,${DIR}," config/zebra_log.xml
sed -i "s,ZebraDB_PATH,${DIR}," src/tools/save/main.go
sed -i "s,ZebraDB_PATH,${DIR}," src/tools/restore/main.go
