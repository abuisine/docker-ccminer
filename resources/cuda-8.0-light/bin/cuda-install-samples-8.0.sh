#!/bin/sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin;
SAMPLES_SRC=`dirname $0`/../samples;

if [ -z "$1" ]; then
    echo "Error: target directory missing";
    echo "Usage: cuda-install-samples-8.0.sh <target directory>";
    echo "       Will append NVIDIA_CUDA-8.0_Samples to <target directory>";
    exit 1;
fi

SAMPLES_DIR=$1;
echo $SAMPLES_DIR | grep -q "/$"
if [ $? -ne 0 ]; then
    SAMPLES_DIR=$SAMPLES_DIR"/";
fi
SAMPLES_DIR=$SAMPLES_DIR"NVIDIA_CUDA-8.0_Samples";

mkdir -p "$SAMPLES_DIR" >/dev/null 2>&1;

if [ -d "$SAMPLES_DIR" -a -w "$SAMPLES_DIR" ]; then
    echo "Copying samples to $SAMPLES_DIR now...";
    cp -R $SAMPLES_SRC/* "$SAMPLES_DIR";
    echo "Finished copying samples.";
else
    echo "Do not have permissions to write to $SAMPLES_DIR";
    exit 1;
fi

exit 0;
