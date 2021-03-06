# Terraform

## Build docker image

```bash

make docker-build
```

## Terraform Conventions

tfvar files are setup per environment for inheritance and directory based:

- [environment].tfvars are for environment specific configuration.
- terraform.tfvars are global (all environments)

```
[root]
 |-- production.tfvars
 |-- staging.tfvars
 |-- development.tfvars
 |-- terraform.tfvars
    |-- workspace
        |-- production.tfvars
        |-- terraform.tfvars
```

By default terraform loads ```terraform.tfvars``` from the current directory. 

Important! ```-var-file``` flags are proccessed in order.

Example: terraform usage for production from within the workspace would be:

```bash
terraform apply -var-file=../terraform.tfvars -var-file=../production.tfvars -var-file=production.tfvars
```

There are wrapper scripts in the docker image to enforce these conventions and setup the remote state and locking

Instead of terraform plan/apply, simply use:

```bash
plan

apply

destroy
```

## Wrapper Scripts

There are wrapper scripts for common operations

## Backend State Storage

```bash
export STATE_STORE=AWS
```

- backend-config

## Secrets 

```bash
export SECRET_STORE=AWS
```
- get-secret [key]
- put-secret [key] [value] [optional: description]


## File storage

```bash
export FILE_STORE=AWS
```
- get-file [remote] [local]
- put-file [local] [remote]

## Derived docker images setting default tags in terraform

```docker
ARG COMPANY_NAME="default"
ENV COMPANY_NAME=${COMPANY_NAME}

# setting company name tags in old terraform files where interpolation didn't work
RUN find /terraform/modules *.tf -type f | xargs | xargs sed -i "s/company:/${COMPANY_NAME}:/g"
```