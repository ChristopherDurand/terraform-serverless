This repository is a test -- I wanted to play around with Terraform and learn about API Gateways as a serverless backend.

This requires that you have a domain whose DNS is controlled by R53.

In `/infrastructure`, there are these resources created --
  - One lambda for each file in `/front-end`
  - API Gateway HTTP API
    - One API Gateway Route & Integration for each lambda
    - One Stage, and one Deployment
  - an S3 bucket
    - gets the contents of `/front-end/build`
    - Resource policy to only allow the Cloudfront Distribution to access
  - CloudFront distribution
    - Serves the API Gateway for the path prefix `/api`
    - Serves the S3 bucket otherwise
    - TLS Certificate
    - DNS Record
    - OAI for S3 bucket


TODO:
  - Verify functionality for other lambda runtimes
  - Find a better way to deploy the static assets to S3 origin
    - The mime types were a problem -- I found a hacky solution