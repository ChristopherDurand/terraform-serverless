#!/bin/bash
S3_BUCKET="terraform-serverless-example-133337"

rm -rf "./build"
mkdir build
cd example

echo "building version $1"

for file in *.js
do
  name=$( echo "$file" | cut -f 1 -d '.')
  echo "zipping $name..."
  zip "../build/$name.zip" "$name.js"
  echo "copying $name to s3..."
  aws s3 cp "../build/$name.zip" "s3://$S3_BUCKET/$1/$name.zip"
  echo "$name.js uploaded to s3"
done
rm -r ../build

echo "version $1 successfully built"
# rm -f example.zip
# cd example
# zip ../example.zip main.js
# cd ..
