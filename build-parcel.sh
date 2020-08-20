#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <apache-flume-1.9.0-bin.tar.gz>"
  exit 1
fi

FLUME_TAR_PATH=$1
FLUME_TAR_NAME=$(basename $FLUME_TAR_PATH)

VALIDATOR_DIR=${VALIDATOR_DIR:-~/trash/cm_ext}
POINT_VERSION=${POINT_VERSION:-1}

SRC_DIR=${SRC_DIR:-parcel-src}
BUILD_DIR=${BUILD_DIR:-build-parcel}
OS_VER=-el7

PARCEL_NAME=$(echo FLUME-1.9.${POINT_VERSION}.flume.p0.${POINT_VERSION})
SHORT_VERSION=$(echo 1.9.${POINT_VERSION})
FULL_VERSION=$(echo ${SHORT_VERSION}.flume.p0.${POINT_VERSION})

# Make Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make directory
mkdir $BUILD_DIR

# FLUME Meta
cp -r $SRC_DIR $BUILD_DIR/$PARCEL_NAME

# Create Copy
cp $FLUME_TAR_PATH $BUILD_DIR/$PARCEL_NAME
cd $BUILD_DIR/$PARCEL_NAME
tar xvfz $FLUME_TAR_NAME
rm -f $FLUME_TAR_NAME
mv apache-flume-*/* .
rmdir apache-flume-*
chmod -R 755 ./lib ./conf

# move into BUILD_DIR
cd ..

for file in `ls $PARCEL_NAME/meta/**`
do
  sed -i "s/<VERSION-FULL>/$FULL_VERSION/g"     $file
  sed -i "s/<VERSION-SHORT>/${SHORT_VERSION}/g" $file
done

# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -d $PARCEL_NAME

 # http://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true

# create parcel
tar zcvf ${PARCEL_NAME}-el7.parcel ${PARCEL_NAME}

# validate parcel
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -f ${PARCEL_NAME}-el7.parcel

# create manifest
$VALIDATOR_DIR/make_manifest/make_manifest.py
