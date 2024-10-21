#!/bin/bash
aws dynamodb create-table \
    --endpoint-url "http://localhost:8989" \
    --table-name Participation \
    --attribute-definitions \
        AttributeName=pk,AttributeType=S \
        AttributeName=sk,AttributeType=S \
    --key-schema \
        AttributeName=pk,KeyType=HASH \
        AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws dynamodb create-table \
    --endpoint-url "http://localhost:8989" \
    --table-name User \
    --attribute-definitions \
        AttributeName=pk,AttributeType=S \
        AttributeName=sk,AttributeType=S \
    --key-schema \
        AttributeName=pk,KeyType=HASH \
        AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Create the DynamoDB table
aws dynamodb create-table \
    --endpoint-url "http://localhost:8989" \
    --table-name app-defcon-run \
    --attribute-definitions \
        AttributeName=pk,AttributeType=S \
        AttributeName=sk,AttributeType=S \
        AttributeName=GSI1PK,AttributeType=S \
        AttributeName=GSI1SK,AttributeType=S \
    --key-schema \
        AttributeName=pk,KeyType=HASH \
        AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --global-secondary-indexes \
        '[
            {
                "IndexName": "GSI1",
                "KeySchema": [
                    {"AttributeName":"GSI1PK","KeyType":"HASH"},
                    {"AttributeName":"GSI1SK","KeyType":"RANGE"}
                ],
                "Projection": {
                    "ProjectionType":"ALL"
                },
                "ProvisionedThroughput": {
                    "ReadCapacityUnits": 5,
                    "WriteCapacityUnits": 5
                }
            }
        ]'

# Enable TTL on the DynamoDB table
aws dynamodb update-time-to-live \
    --endpoint-url "http://localhost:8989" \
    --table-name app-defcon-run \
    --time-to-live-specification "Enabled=true, AttributeName=expires"