#!/bin/bash

# test to install outside repo and test DNS

echo "Adding additional php repo..."
sudo add-apt-repository -y ppa:ondrej/php

echo "Installing PHP..."
sudo apt install -y php
