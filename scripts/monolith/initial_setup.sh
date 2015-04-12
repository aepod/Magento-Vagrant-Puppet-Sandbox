#!/bin/bash

# Running puppet here, because it fails as an provider in vagrant
puppet agent -t
 