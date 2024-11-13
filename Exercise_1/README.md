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

## Technical Glossary

- **C2 Server (Command & Control)**: A command and control server is a fundamental tool in penetration testing that allows for the management and coordination of simulated security operations. It acts as a central control point for security assessments.

- **C2 Redirector**: An infrastructure component that helps obscure the real location of the C2 server, functioning as an intermediary between agents and the main server. It enhances operational security and makes detection more difficult.

- **Infrastructure as Code (IaC)**: A methodology that allows us to manage and provision infrastructure through code instead of manual processes. Terraform is one of the most popular tools for IaC.

- **DNS (Domain Name System)**: A system that translates human-readable domain names to IP addresses. Managing DNS zones is crucial for correctly directing traffic in our infrastructure.

- **Apache**: A popular open-source web server that we can configure as a redirector for our C2 operations.

- **Terraform**: An IaC tool that allows us to define and create infrastructure across multiple cloud providers in a consistent and reproducible manner.

- **S3 Bucket**: An AWS cloud storage service that we can use to securely and centrally store the state of our Terraform infrastructure.
