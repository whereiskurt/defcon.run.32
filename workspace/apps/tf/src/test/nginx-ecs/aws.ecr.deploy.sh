export AWS_PROFILE=application
export AWS_REGION=us-east-1

export REPO_URL=427284555693.dkr.ecr.us-east-1.amazonaws.com
export REPO_NAME=rabbit.auth.defcon.run
export REPO_TAG=latest
export LOCAL_TAG=rabbit-auth

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt -subj "/C=US/ST=Nevada/L=LasVegas/O=DEFCON.run/OU=Engineering/CN=rabbit.app.defcon.run"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_URL

docker build --platform=linux/amd64 -f Dockerfile.nginx -t $LOCAL_TAG .
docker tag $LOCAL_TAG:$REPO_TAG $REPO_URL/$REPO_NAME:$REPO_TAG
docker push $REPO_URL/$REPO_NAME:$REPO_TAG

# PAGER= aws ecs update-service --cluster defcon-run --service web_service-rabbit --force-new-deployment
