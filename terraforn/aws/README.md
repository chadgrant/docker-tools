# Terraform

## Setup dependencies

Install docker, aws cli and jq

Linux:
```bash
apt-get install awscli jq
```

OSX:
```bash
brew install awscli jq
```

## Configure local AWS environment

Obtain / Create AWS access keys/secrets and set them up locally with:

```bash
aws configure --profile production
aws configure --profile staging
aws configure --profile development
```

## Configure local environment for MFA login

By default we enforce multi factor auth for access keys. You will need to use the access keys to obtain a session token before using the aws-cli.

There are aliases functions provided in [bash_aliases](bash_aliases) that make mfa usage easier.

You can set them up in your ~/.bash_aliases or use : 

```bash
 source bash_aliases 
```

You can also setup defaults in your ~/.bash_profile :
```bash
export AWS_DEFAULT_USER=user.name
export AWS_DEFAULT_PROFILE=development
```

## Bash aliases usage

To switch between aws profiles (which are also environment names by convention) :
```bash
awsprofile [environment]
```

To switch profiles and obtain a session token:
```bash
awsmfa [environment] [username] [mfacode]
```

After setting up auth with awsmfa, run docker passing all the environment variables:
```bash
cd terraform/setup

docker-terraform
```