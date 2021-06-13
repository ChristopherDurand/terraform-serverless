This repository is a test -- I wanted to play around with Terraform and learn about API Gateways as a serverless backend.

This requires that you have a domain whose DNS is controlled by R53.

## How to use this
1. In `/front-end/build`, make sure you have static website contents and an `index.html`.
  - You can initialize a react app in `/front-end` and run `npm run build` to do this.
2. in `/functions`, define your lambdas as single files. 
3. in `/infrastructure/.auto.tfvars` --
  - within the `lambdas` map, define the following needed information:
    - handler -- Entrypoint for the lambda. check AWS Lambda Documentation
    - runtime -- Runtime for the lambda. Check AWS Lambda Documentation
    - memory_size -- Amount, in megabytes, of memory the lambda gets.
    - route_key -- `"GET /api/pets"` means the lambda is invoked on a `GET` request to `/api/pets`.
  - Come up with a unique bucket name, and set that as the `s3_bucket` var.
  - Put the domain name you have in the `domain` variable.
4. One you have your lambdas a


These are the resources that are created --
  - One lambda for each file in `/front-end`
  - API Gateway HTTP API
    - One API Gateway Route & Integration for each lambda
    - One Stage, and one Deployment
  - S3 bucket
    - with the contents of `/front-end/build`
    - with Resource policy to only allow the Cloudfront Distribution to access
  - CloudFront distribution
    - Serves the API Gateway for the path prefix `/api`
    - Serves the S3 bucket otherwise
    - TLS Certificate
    - DNS Record
    - OAI for S3 bucket


TODO:
  - Verify functionality for other lambda runtimes
  - Find a better way to deploy the static assets to S3 origin
    - The mime-types were a problem here. It would probably be far better to make an NPM script that does something like `bash ./deploy-to-s3.sh && cd infrastructure && terraform deploy`, where `deploy-to-s3.sh` does something like `aws s3 rsync ... ...` It works for now, though. I'm sure there's a mime type not covered in that list, though.
  - Play around with DynamoDB or Aurora Serverless as a serverless DB for the lambdas
  - Implement something other than hello world using this