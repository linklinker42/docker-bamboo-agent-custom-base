#!/bin/bash
set -euo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

# Allows you to actually change the URL after the initial run.
wrapperFix="wrapper.app.parameter.2=$BAMBOO_URL/agentServer/"

if [ -f /home/bamboo/bamboo-agent-home/conf/wrapper.conf ]; then
    sed -i "s/^wrapper\.app\.parameter\.2=.*/${wrapperFix//\//\\/}/" /home/bamboo/bamboo-agent-home/conf/wrapper.conf
fi

if [ -z ${BAMBOO_URL} ]; then
    echo "Please run the Docker image with Bamboo URL as the first argument"
    exit 1
fi

if [ ! -f ${BAMBOO_CAPABILITIES} ]; then
    cp ${INIT_BAMBOO_CAPABILITIES} ${BAMBOO_CAPABILITIES}
fi

if [ -z ${SECURITY_TOKEN+x} ]; then   
    exec java ${VM_OPTS:-} -jar "${AGENT_JAR}" "${BAMBOO_URL}/agentServer/"
else 
    exec java ${VM_OPTS:-} -jar "${AGENT_JAR}" "${BAMBOO_URL}/agentServer/" -t "${SECURITY_TOKEN}"
fi 
