# aviatrix-controller-jumpstart-terraform

This terraform is meant to be used as a jumpstart means of launching a new Aviatrix controller through Terraform Cloud.  

aviatrix.tf contains the modules and usage as outlined in https://github.com/AviatrixSystems/terraform-modules.  
aviatrix.tf also has an additional resource not outlined in their repo for the creation of the keypair it needs.  
network.tf contains what we consider to be the minimum network resources to launch said controller.  

# Usage:
Replace organization and workspace names in main.tf with your own Terraform Cloud respective names.  
This must be done instead of using variables as variable iterpolation can not be done in a terraform config block.  

Configure variables in Terraform Cloud  
Note that the network made here is NOT to be the transit network and is instead a network for the sole sake of the controller  
Keep this in mind when making the vpc and subnet cidrs  
The key variables are needed to ssh onto the ec2 running the container  
Name is used as an Id reference by ec2, while the public key is the public key value rather than file reference  
Ex:  
```
ssh-keygen -f aviatrix  
```
Open the resulting aviatrix.pub and copy the contents to the variable in tf cloud named public_key.  

An alternative to providing the key this way is to manually go into the aws console and create a keypair in ec2.  
Then all that is needed is to update this terraform by deleting the aws_key_pair resource and changing where it is referenced in the Aviatrix terraform module to be instead the var.keypair_name.  


# Things to keep in mind:
When destroying this stack, the controller has termination protection.  
After selecting the ec2 and disabling the termination protection in the console ABSOLUTELY DO NOT TERMINATE THE EC2 YOURSELF WHILE YOU'RE RIGHT THERE.  
The Aviatrix modules do a count on their running controllers and upon finding the count to be 0, error instead of just proceeding with the delete.  

The Aviatrix module doesn't clearly make mention of password restrictions, but the lambda that executes fails passwords that aren't strong.  
Recommend at least setting that password as 8 or more characters, having both upper and lower case, a number, and a special character to satisfy the check.  