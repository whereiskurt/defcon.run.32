## How to Deploy

1. An AWS configuration that support management+application+terraform accounts is setup. These can call be the same AWS account or different.
```
[sso-session Developer]
sso_start_url = https://whereiskurt.awsapps.com/start/
sso_region = us-east-1
sso_registration_scopes = sso:account:access

[profile management]
sso_session = Developer
sso_account_id = [AWS_MANAGEMENT_ACCOUNT]
sso_role_name = HostedZoneAdmin

[profile application]
sso_session = Developer
sso_account_id = [AWS_APP_ACCOUNT]
sso_role_name = AdministratorAccess

[profile terraform]
sso_session = Developer
sso_account_id = [AWS_APP_ACCOUNT]
sso_role_name = AdministratorAccess
```

1. The following commands ensure a successful build: 
```
aws sso login --sso-session=Developer
export TF_VAR_githubdeploykey="$(cat /Users/khundeck/.ssh/githubdeploy.readonly.key)"
source apps/tf/src/.env.template.sh
nx run tf:apply --verbose
./apps/cms/src/deploy.strapi.sh

npm run strapi transfer -- --to https://strapi.cms.defcon.run/admin/

nx run web-user:build --verbose
docker build --platform=linux/amd64 -t $LOCAL_TAG -f Dockerfile.webuser.prod apps/web/user/.next
./workspace/deploy.webuser.sh
```

## Reset Strapi Password
```
npm run strapi admin:reset-user-password --email="whereiskurt@gmail.com" --password='StrapistrapiStrapistrapi1234!!!'
```

## Transfer
```
npm run strapi transfer -- --to https://strapi.cms.defcon.run/admin/
```