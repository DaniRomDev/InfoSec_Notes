#!/bin/bash

CURRENT_DIR=$(pwd)

chmod -R +x $CURRENT_DIR/*.sh

# Bandit 0 
expect $CURRENT_DIR/expect.exp bandit0 bandit0 $CURRENT_DIR/bandit0.sh
