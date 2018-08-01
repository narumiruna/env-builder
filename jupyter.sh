#!/bin/bash

PYTHON=$(which python)
PYTHON3=$(which python3)

if [ -n $PYTHON3 ]
then
    $PYTHON3 -m pip install jupyter
elif [ -n $PYTHON ]
then
    $PYTHON -m pip install jupyter
fi

