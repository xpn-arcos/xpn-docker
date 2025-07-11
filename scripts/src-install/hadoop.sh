#!/bin/bash
set -x

# 1) Check arguments
if [ $# -lt 1 ]; then
	echo "Usage: $0 <full path where software will be installed>"
	exit
fi

# 2) Get arguments
DESTINATION_PATH=$1

# 3) Download and install Spark
mkdir -p ${DESTINATION_PATH}
wget wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz -O ${DESTINATION_PATH}/hadoop-341.tar.gz
tar zxf ${DESTINATION_PATH}/hadoop-341.tar.gz  -C ${DESTINATION_PATH}
ln -s   ${DESTINATION_PATH}/hadoop-3.4.1          ${DESTINATION_PATH}/hadoop
touch /home/lab/.profile

# 4) PATH
echo "# Hadoop"                                          >> /home/lab/.profile
echo "export PATH=${DESTINATION_PATH}/hadoop/bin:\$PATH" >> /home/lab/.profile

