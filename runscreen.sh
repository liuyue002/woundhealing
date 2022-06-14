#!/bin/bash
screen -S "${1}" -d -m ./run_job.sh ${1}
