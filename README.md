This repository is a test -- I wanted to play around with Terraform and learn about API Gateways as a serverless backend.

This requires that you have a domain whose DNS is controlled by R53.

## How to use this
1. Set up an S3 bucket that will serve as your state store. 
    - **Make sure it's private!**
    - `cd` into `infrastructure` 
    - run `terraform init`
      - provide the bucket name for your private state store
    - Do not delete this bucket while the application is deployed. This is how Terraform knows what is deployed.
2. In `/front-end/build`, make sure you have static website contents and an `index.html`.
    - You can initialize a react app in `/front-end` and run `npm run build` to do this, similar to this repository.
3. in `/functions`, define your lambdas as single files. 
    - These will be the individual endpoints of your API. There are two examples in this project.
4. in `/infrastructure/.auto.tfvars` --
    - within the `lambdas` map, define the following needed information:
      - handler -- Entrypoint for the lambda. check AWS Lambda Documentation
      - runtime -- Runtime for the lambda. Check AWS Lambda Documentation
      - memory_size -- Amount, in megabytes, of memory the lambda gets.
      - route_key -- `"GET /api/pets"` means the lambda is invoked on a `GET` request to `/api/pets`.
      - There is an example commented out to help with this
    - Come up with a unique bucket name, **different from your state store**, and set that as the `s3_bucket` var.
    - Put the domain name you have in the `domain` variable.
5. Once you are ready to deploy:
    - `cd` into `infrastructure` 
    - run `terraform apply`
6. If you update your application and want to update the deployment:
    - run `terraform apply` from within `./infrastructure`
7. If you want to teardown everything:
    - run `terraform destroy`


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
  - Split off Build & Deploy
    - Zipping lambdas and uploading static assets should be separate from deployment via Terraform
  - Play around with DynamoDB or Aurora Serverless as a serverless DB for the lambdas
  - Implement something other than hello world using this
  - Figure out how to test lambdas locally -- no way to test the app locally right now
