export AWS_PROFILE=application
export AWS_REGION=us-east-1

ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
export REPO_URL="${ACCOUNT_NUMBER}.dkr.ecr.us-east-1.amazonaws.com"

export REPO_NAME=rabbit.app.defcon.run
export REPO_TAG=latest
export LOCAL_TAG=app-prod

nx run web-user:build

docker build --platform=linux/amd64 -t $LOCAL_TAG -f Dockerfile.webuser.prod dist/webuser

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_URL

docker tag $LOCAL_TAG:$REPO_TAG $REPO_URL/$REPO_NAME:$REPO_TAG
docker push $REPO_URL/$REPO_NAME:$REPO_TAG

PAGER= aws ecs update-service --cluster defcon-run --service app-defcon-run --force-new-deployment