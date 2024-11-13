# Exercise 4: Deploy a Content Delivery Network Distribution (AWS CloudFront) to Redirect C2 Traffic

Get ready to take your C2 infrastructure to the next level! In this exciting exercise, we will use the power of CDNs to make our C2 traffic even stealthier. Follow these steps:

1. Deploy C2 redirection using the CloudFront CDN.
2. Configure C2 redirection in the CloudFront CDN.
3. Reconfigure C2 listeners to communicate with the CDN URL.
4. Generate C2 payloads that connect to the CDN URL.

## Instructions for Configuring the CloudFront Distribution

In the `cf_distributions.tf` file, you will find several placeholders that need to be replaced with specific values for your configuration. Here's how to do it:

- `<REDIRECTOR_DOMAIN_TLD>`: This is a unique identifier for your CloudFront distribution. It should be replaced with your redirector's domain name, for example, `example_com_cdn_1`.

- `<REDIRECTOR_DOMAIN.TLD>`: This is the domain name of the origin server (redirector) that CloudFront will use to distribute the content. Replace it with your actual domain, for example, `example.com`.

- `<OPERATIONYEAR-MONTH-OPERATIONNAME-OPERATIONTYPE>`: This is a descriptive comment for your CloudFront distribution. It should be replaced with specific details of your operation, for example, `2024-NOV-ITPR-OP` for a Red Team operation at ITPR or `2024-DEC-BANCOPOPULAR-PTE` for a Purple Team exercise at Banco Popular.

## Exercise 4 Challenges

Ready for more? Try these additional challenges:

1. Automate the deployment and configuration of Azure FrontDoor CDN for C2 redirection.
2. Repeat challenge #1, but with Google CDN.
3. Now do it with Fastly.
4. How about with CloudFlare?
5. Implement redirection using serverless functions in the cloud provider of your choice.
6. Modify the Terraform for this exercise to use an AWS S3 bucket to store the state file. Research and understand why keeping a locally stored state file is a bad idea and what the associated risks are.

## Technical Glossary

- **CDN (Content Delivery Network)**: A system of distributed servers that deliver web content based on the user's geographic location, improving speed and reliability.
- **AWS CloudFront**: A fast and highly secure CDN service from Amazon Web Services, ideal for distributing content with low latency and high transfer speeds.
- **C2 Redirection**: A technique to hide the real location of the command and control (C2) server using intermediaries like CDNs.
- **C2 Listeners**: Components of the C2 server that wait for and process incoming connections from deployed agents.
- **C2 Payload**: Code or data sent to a compromised system to establish communication with the C2 server.
- **Azure FrontDoor**: A CDN and load balancing service from Microsoft Azure, similar to CloudFront but with Azure-specific features.
- **Google CDN**: A CDN solution from Google Cloud Platform, offering fast and secure content delivery globally.
- **Fastly**: A high-performance CDN known for its advanced configuration capabilities and low latency.
- **CloudFlare**: A provider of CDN and web security services, popular for its DDoS protection and global network.
- **Serverless Functions**: A code execution model where the cloud provider manages the infrastructure, allowing developers to focus solely on the code.
- **Terraform**: An infrastructure as code tool that allows you to define and provision infrastructure resources declaratively.
- **S3 Bucket**: An object storage service from Amazon Web Services, useful for storing and retrieving any amount of data.
- **Terraform State File**: A file that Terraform uses to keep track of managed resources and their current state.
