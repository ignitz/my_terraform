#!/bin/bash

echo -e 'y\n' | ssh-keygen -t rsa -f modules/key_pair/keys/id_rsa -P ""
