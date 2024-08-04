# Exercise 1: Deploy 1 C2 Teamserver and 1 C2 Redirector

- Replace string "`<REDIRECTOR_DOMAIN.TLD>`" with value
- Replace string "`<REDIRECTOR_DOMAIN_TLD>`" with representative value (don't use '.')
- Deploy a C2 server with IaC
- Deploy a C2 redirector with IaC
- Update DNS hosted zone with redirector's IPv4

## Exercise 1 challenges

1. Increase the number of redirectors deployed using terraform
2. How would you address handling multiple domains using Apache? What architecture would you implement?
3. Make the Terraform for this exercise use an AWS S3 bucket to store the state file; research and understand why keeping a locally stored state file is bad idea and what are the risks.
