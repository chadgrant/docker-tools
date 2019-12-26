#!/bin/sh

eval $(tfvars | while read v; do echo "export $v"; done)

eval $(tfvars | while read v; do echo "export TF_VAR_$(echo $v | tr '[:upper:]' '[:lower:]')"; done)

exec "$@"