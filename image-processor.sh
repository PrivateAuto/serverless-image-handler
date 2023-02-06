
export MAIN_DIRECTORY=$PWD

if [ -z "${AWS_REGION}" ] ; then
  echo "AWS_REGION must be set."
  exit -1
fi

if [ -z "${ENV_NAME}" ] ; then
  echo "ENV_NAME must be set (ops, dev, qa, live)."
  exit -1
fi

export AWS_ACCOUNTNO=`aws sts get-caller-identity --query Account --output text`
export BUCKET_PREFIX=pa-build-cache-${ENV_NAME}
export BUCKET_NAME=$BUCKET_PREFIX-$AWS_REGION 
export SOLUTION_NAME=PrivateAutoImageProcessing
export VERSION=1.0.5

cd $MAIN_DIRECTORY/deployment
chmod +x run-unit-tests.sh
./run-unit-tests.sh

cd $MAIN_DIRECTORY/deployment
chmod +x build-s3-dist.sh
./build-s3-dist.sh $BUCKET_PREFIX $SOLUTION_NAME $VERSION

echo " aws s3 sync . s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION "
aws s3 mb s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION

cd $MAIN_DIRECTORY/deployment/regional-s3-assets
aws s3 sync . s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION 

cd $MAIN_DIRECTORY/deployment/global-s3-assets
aws s3 sync . s3://$BUCKET_NAME/$SOLUTION_NAME/$VERSION 

