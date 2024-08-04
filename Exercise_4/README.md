# Exercise 4: Deploy 1 Content Delivery Network Distribution (AWS CloudFront) to forward C2 traffic

- Deploy C2 redirection using CloudFront CDN
- Configure C2 redirection using CloudFront CDN
- Reconfigure C2 listeners to call-back to CDN URL
- Generate C2 Payloads to call-back to CDN URL

## Exercise 4 challenges

1. Automate the deployment and configuration of Azure FrontDoor CDN for C2 redirection
2. Same as #1 but for Google CDN
3. Same as #1 but for Fastly
4. Same as #1 but for CloudFlare
5. Same as #1 but for serverless functions in a Cloud Service Provider of your choice
6. Make the Terraform for this exercise use an AWS S3 bucket to store the state file; research and understand why keeping a locally stored state file is bad idea and what are the risks.