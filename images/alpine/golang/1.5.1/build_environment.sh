#!/bin/bash

#if ( find /src -maxdepth 0 -empty | read v );
if ( find /src -maxdepth 0 -type f | read v );
then
    echo "Error: Must mount Go source code into /src directory"
    exit 990
fi
