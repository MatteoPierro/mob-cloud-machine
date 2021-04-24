# A EC2 throwaway instance to MOB 

### Introduction

In order to learn how to set up an AWS instance on which we can mob together, we decided to try to set up our own instance taking inspiration from the [instructions from Jay Bazuzi and Llewellyn Falco](https://docs.google.com/document/d/1DyTemsYBu2LUhrwwCdNuPQDWj3f_yfMj3otaoEZZRC4/edit).

### Install the prerequisites

```bash
brew install awscli
brew install terraform
terraform init
```

### Current Instructions to Run

1. `terraform apply` (on @MatteoPierro machine)
1. Connect to instance. Username: `Administrator` Pwd: [See step above]
1. Launch Administrator Powershell console (Windows Key + x if you have it)
1. Run: `Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/approvals/ApprovalTests.java.StarterProject/master/install.windows.ps1 | Invoke-Expression`
1. When done: `terraform destroy`


### Commands used

1. `ssh-keygen -m PEM`
2. Command for getting the windows admin password data of the instance: `aws ec2 get-password-data --instance-id  i-1234567890abcdef0 --priv-launch-key C:\Keys\MyKeyPair.pem`

### Relevant links

1. Machine instance IP address: ``
2. [How to get password data for an Amazon Windows AMI](https://docs.aws.amazon.com/cli/latest/reference/ec2/get-password-data.html#examples)
3. [How do I retrieve my Windows administrator password after launching an instance?](https://aws.amazon.com/premiumsupport/knowledge-center/retrieve-windows-admin-password/)
4. [Jay Bazuzi Script for Java setup](https://github.com/JayBazuzi/machine-setup/blob/main/dev_environments/java.ps1)
