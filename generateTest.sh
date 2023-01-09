#!/bin/bash
# University of Michigan EECS 370
# Author: Maximos Nolan

# Define output colors

Red=`tput setaf 1`
Green=`tput setaf 2`
Other=`tput setaf 3`

## Generate output files for given test cases
for test in *.as; do
    outFile="${test%%.*}".out.mc
    ./assembler $test $outFile
done 

## Create ground truth for all test cases
if [ "$1" == "correct" ]; then
       mkdir -p groundTruth
       for test in *.as; do
       outFile="${test%%.*}".out.mc
       ./assembler $test groundTruth/$outFile
       done
fi

## Compare current output for all test cases

if [ "$1" == "compare" ]; then
       for test in *.as; do
       outFile="${test%%.*}".out.mc
       ./assembler $test $outFile
       numCorrect=0
       numTotal=0
       echo "Test case " $test " : "
       if cmp -s $outFile groundTruth/$outFile; then
            echo "${Green}PASSED"
            let "numCorrect +=1"
       else 
            echo "${Red}FAILED"
       fi
       let "numTotal +=1"
       echo "${Other}$numCorrect /" $numTotal "produced the same output as the ground truth"
       done
fi

if [ "$1" == "clean" ]; then
       rm -rf groundTruth
fi

if [ "$1" == "help" ]; then
      echo "${Green} EECS 370 regression testing: "
      echo "${Red} <compare> ${Other}compare the output of your current assembler against the output in ${Red}groundTruth directory."
      echo "${Red} <correct> ${Other}create ${Red}correct ${Red}output ${Other}into the directory ${Red}groundTruth. ${Other}These output files are deemed to be ${Red}correct ${Other}and can be used in regression testing."
      echo "${Red} <clean> ${Other}remove contents of ${Red}groundTruth."
      echo "${Green} usage: run  $./generateTest <option>."
fi


