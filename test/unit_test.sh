#!/bin/bash

POST_JSON=post.json
POST_OUTPUT=post.output
GET_OUTPUT=get.output
ORANGE="\e[1;38m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
END="\e[0m"

echo -e "$ORANGE=============================================================== $END"
echo -e "$BLUE    Testing Post request... $END"
echo -e "$ORANGE=============================================================== $END"

echo "setting these..."
cat post.json

echo "Post response..."
./curl_replayd.sh localhost POST $POST_JSON > $POST_OUTPUT

if grep "Successfully accepted" $POST_OUTPUT; then
   echo -e "$YELLOW--- Testing Post Succeeded $END" 
else 
   echo -e "$RED--- Testing Post Failed $END" 
   rm -f $POST_OUTPUT
   exit 1
fi
rm -f $POST_OUTPUT


echo -e "$ORANGE=============================================================== $END"
echo -e "$BLUE    Testing Get request to make sure post really worked... $END"
echo -e "$ORANGE=============================================================== $END"
echo "Get response..."
./curl_replayd.sh localhost GET > $GET_OUTPUT

if cmp -s "$POST_JSON" "$GET_OUTPUT"; then
  echo -e "$YELLOW--- Get successfully worked! $END"
else
  echo -e "$RED Get failed $END"
  rm -f $GET_OUTPUT
  exit 1
fi
rm -f $GET_OUTPUT

# Testing Put request
PUT_JSON=put.json
PUT_OUTPUT=put.output
echo -e "$ORANGE=============================================================== $END"
echo -e "$BLUE    Testing Put request... $END"
echo -e "$ORANGE=============================================================== $END"

echo "setting these..."
cat $PUT_JSON

echo "Put response..."
./curl_replayd.sh localhost PUT $PUT_JSON > $PUT_OUTPUT

if grep "Successfully updated" $PUT_OUTPUT; then
   echo -e "$YELLOW--- Testing Put Succeeded $END" 
else 
   echo -e "$RED--- Testing Put Failed $END" 
   #rm -f $PUT_OUTPUT
   exit 1
fi
rm -f $PUT_OUTPUT


echo -e "$ORANGE=============================================================== $END"
echo -e "$BLUE    Testing Get request to make sure put really worked... $END"
echo -e "$ORANGE=============================================================== $END"
echo "Get response..."
./curl_replayd.sh localhost GET > $GET_OUTPUT

if cmp -s "$PUT_JSON" "$GET_OUTPUT"; then
  echo -e "$YELLOW--- Get successfully worked! $END"
else
  echo -e "$RED Get failed $END"
  rm -f $GET_OUTPUT
  exit 1
fi
rm -f $GET_OUTPUT
