#!/usr/bin/env bash

set -e

JAR_DIR=$1
DEST_DIR=$2

echo "Installing ${JAR_DIR}...";
java -jar ${JAR_DIR}/installer.jar -console << EOF













1
${DEST_DIR}
1
EOF
