#!/bin/bash

echo "==============================================================="
echo "Testing Post request..."
echo "==============================================================="

echo "setting these..."
cat post.json

echo "Post response..."
./curl_replayd.sh > post.output

if grep "Successfully updated" post.output; then
   echo "--- Testing Post Succeeded" 
else 
   echo "--- Testing Post Failed" 
   rm -f post.output 
   exit 1
fi
rm -f post.output


echo "==============================================================="
echo "Testing Get from previous post"
echo "==============================================================="
echo "Get response..."
curl localhost:6080 > get.output

if cmp -s "post.json" "get.output"; then
  echo "Get successfully worked!"
else
  echo "Get failed"
fi
rm -f get.output
