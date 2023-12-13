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
cat <<EOF >> /var/write_cache.py
from rediscluster import RedisCluster
import logging
import boto3
import sys

def main():
    CityName = input("Enter a City Name: ")
    session = boto3.Session(region_name='$AWS_REGION')
    auth_token = get_secret(session)
    elasticache_endpoint = get_elasticache_endpoint(session)
    elasticache_port = get_elasticache_port(session)
    write_into_redis_cluster(
        elasticache_endpoint, 
        elasticache_port, 
        auth_token, 
        CityName)

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

def write_into_redis_cluster(endpoint, port, auth, cityname):
    logging.basicConfig(level=logging.INFO)
    redis = RedisCluster(startup_nodes=[{
        "host": endpoint['Parameter']['Value'],
        "port": port['Parameter']['Value']}], 
        decode_responses=True,skip_full_coverage_check=True,ssl=True, 
        password=auth['SecretString'])
    if redis.ping():
        logging.info("Connected to Redis")
        redis.set('City', cityname)
        print("The city name entered is updated in the Redis cache cluster.")
    redis.close()
main()
EOF