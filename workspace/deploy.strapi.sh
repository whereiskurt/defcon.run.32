export AWS_PROFILE=application
export AWS_REGION=us-east-1

ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
export REPO_URL="${ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com"

export REPO_NAME=rabbit.strapi.cms.defcon.run
export REPO_TAG=latest
export LOCAL_TAG=strapi-prod

docker build --platform=linux/amd64 -t $LOCAL_TAG -f Dockerfile.strapi.prod ./apps/cms/src/

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $REPO_URL

docker tag $LOCAL_TAG:$REPO_TAG $REPO_URL/$REPO_NAME:$REPO_TAG
docker push $REPO_URL/$REPO_NAME:$REPO_TAG

PAGER= aws ecs update-service --cluster defcon-run --service strapi-cms-defcon-run --force-new-deployment