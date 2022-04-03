
export MAIN_DIRECTORY=$PWD

export REGION=us-east-2
export BUCKET_PREFIX=pa-build-cache-ops
export BUCKET_NAME=$BUCKET_PREFIX-$REGION 
export SOLUTION_NAME=PrivateAutoImageProcessing
export VERSION=1.0.1


cd $MAIN_DIRECTORY/deployment
chmod +x run-unit-tests.sh
./run-unit-tests.sh


cd $MAIN_DIRECTORY/deployment
chmod +x build-s3-dist.sh
./build-s3-dist.sh $BUCKET_PREFIX $SOLUTION_NAME $VERSION

cd $MAIN_DIRECTORY/deployment/regional-s3-assets
aws s3 sync . s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION 

cd $MAIN_DIRECTORY/deployment/global-s3-assets
aws s3 sync . s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION 

