#!/bin/bash
java -jar ./ENHSP/enhsp.jar -o $1 -f $2 -planner opt-blind -pe
#java -jar ./ENHSP/enhsp.jar -o $1 -f $2 -anytime -pe