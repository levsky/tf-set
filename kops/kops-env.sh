#!/bin/bash
CLUSTER_NAME="levsky.k8s.local"
ZONES=${ZONES:-"us-west-2a,us-west-2b,us-west-2c"}
NODE_SIZE=${NODE_SIZE:-t3.medium}
MASTER_SIZE=${MASTER_SIZE:-t3.medium}
SSH_PUB=~/.ssh/id_rsa.kubernetes.pub

TF_OUTPUT=$(cd ../vpc-kops && terraform output -json)
BUCKET_NAME="$(echo ${TF_OUTPUT}  | jq -r .kops_s3_bucket.value)"
VPC_ID="$(echo ${TF_OUTPUT}       | jq -r .vpc_id.value)"
DNS_ZONE="$(echo ${TF_OUTPUT}     | jq -r .public_dns_zone_id.value)"
NETWORK_CIDR="$(echo ${TF_OUTPUT} | jq -r .vpc_cidr.value)"

export CLUSTER_NAME="${CLUSTER_NAME}"
export KOPS_STATE_STORE="s3://${BUCKET_NAME}"

kops create cluster $CLUSTER_NAME \
  --node-count 3 \
  --zones $ZONES \
  --node-size $NODE_SIZE \
  --master-size $MASTER_SIZE \
  --master-zones $ZONES \
  --vpc $VPC_ID \
  --network-cidr $NETWORK_CIDR \
  --ssh-public-key $SSH_PUB \
  --networking calico \
  --topology private \
  --dns-zone $DNS_ZONE \
  --yes


  #--networking cni \
  #--bastion="true" \
  #--dns-zone $DNS_ZONE \

echo -e "\nTo make your life easier export environment variables:\n"
echo -e "export CLUSTER_NAME=\"${CLUSTER_NAME}\""
echo -e "export KOPS_STATE_STORE=s3://\"${BUCKET_NAME}\""
