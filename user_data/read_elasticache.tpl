#!/bin/bash
yum update -y
yum install python-pip -y
yum install python3 -y
pip3 install redis-py-cluster
pip3 install boto3
pip3 install botocore
echo "The region value is ${Region}"
AWS_REGION=${Region}
local_elasticache_ep=${elasticache_ep}
local_auth_token=${elasticache_auth_token}
local_elasticache_ep_port=${elasticache_ep_port}
cat <<EOF >> /var/read_cache.py
from rediscluster import RedisCluster
from botocore.exceptions import ClientError
import logging
import boto3

def main():
    session = boto3.Session(region_name='$AWS_REGION')
    auth_token = get_secret(session)
    elasticache_endpoint = get_elasticache_endpoint(session)
    elasticache_port = get_elasticache_port(session)
    read_from_redis_cluster(elasticache_endpoint, elasticache_port, auth_token)

def get_secret(session):
    secret_client = session.client('secretsmanager')
    try:
        get_secret_value_response = secret_client.get_secret_value(
            SecretId='$local_auth_token'
        )
    except ClientError as e:
        raise e
    return get_secret_value_response

def get_elasticache_endpoint(session):
    ssm_client = session.client('ssm')
    return ssm_client.get_parameter(
        Name='$local_elasticache_ep', WithDecryption=True)

def get_elasticache_port(session):
    ssm_client = session.client('ssm')
    return ssm_client.get_parameter(
        Name='$local_elasticache_ep_port', WithDecryption=True)

def read_from_redis_cluster(endpoint, port, auth):
    logging.basicConfig(level=logging.INFO)
    redis = RedisCluster(startup_nodes=[{
        "host": endpoint['Parameter']['Value'],
        "port": port['Parameter']['Value']}], 
        decode_responses=True,skip_full_coverage_check=True,ssl=True, 
        password=auth['SecretString'])
    if redis.ping():
        logging.info("Connected to Redis")
        print("The city name entered is "+redis.get("City"))
    redis.close()
main()
EOF