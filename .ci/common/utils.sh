#!/bin/bash

#  Copyright 2019-present Open Networking Foundation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http:# www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

set -o nounset
set -o errexit

check_iface()
{
    # Check if INTERFACE is visible in "ifconfig -a"
    # Exit for timeout after [timeout] seconds (dfaults to 30 secs).
    # Check is done every [interval] seconds (dfaults to 5 secs).

    if [[ $# -lt 1 ]]; then
        echo "Usage: ${FUNCNAME} if_name [timeout [sec]] [interval [sec]]";
        return 1
    fi

    SECONDS=0
    local INTERFACE=$1
    local TIMEOUT=${2:-30}  # default: 30 sec
    local INTERVAL=${3:-5}  # default: 5 sec
    until ifconfig -a | grep "${INTERFACE}" > /dev/null; do
        if [[ $SECONDS -gt $TIMEOUT ]]; then
            return 1
        fi
        echo "Waiting for ${INTERFACE} to be ready [${SECONDS} sec ...]"
        sleep "${INTERVAL}"
    done

    echo "${INTERFACE} ready!"
    ifconfig -a | grep "${INTERFACE}"
    return 0
}
