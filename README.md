# flume-parcel
1. 下载cloudera的cm_ext项目并编译
git clone https://github.com/cloudera/cm_ext.git
mvn install
2. 下载一个最新的flume，目录假设为 /tmp/flume
wget https://mirrors.bfsu.edu.cn/apache/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
3. 在本项目里运行命令
生成csd
VALIDATOR_DIR=/path-to-cm_ext CSD_NAME=FLUME ./build-csd.sh
生成parcel
POINT_VERSION=1 VALIDATOR_DIR=/path-to-cm_ext OS_VER=el7 PARCEL_NAME=Flume ./build-parcel.sh /tmp/flume/apache-flume-1.9.0-bin.tar.gz
