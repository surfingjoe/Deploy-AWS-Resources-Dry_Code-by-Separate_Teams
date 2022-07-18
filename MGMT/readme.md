# Be sure to change each file in the MGMT folder with appropriate values

This MGMT folder has been created to make sure the following already exists before deploying any AWS resources

1. Go to the "create_s3_bucket" folder, change to appropriate values for your depoyment and run `terraform init` then `terraform apply`
2. Go to the "Create_DynamoDB_Table" and change the region value appropriate to your deployment and run `terraform init` then `terraform apply`
3. Ater an S3 bucket exists by executing step 1, we need to make sure a "terraform.tfstate" actually exists before deploy any resources
   - Change to one of the directories "Dev_remote_state" or "Quality-Assurance_remote_state"
   - Edit the values appropriate for your region and the name of the S3 bucket created in Step 1
   - run `terraform init` then `terraform apply`
   - Note: this must be initiated in its own folder separate from creating DynamoDB lock table, otherwise Terraform will try to create locks now wich we do not want to occur until we are deploying resources not just creating the "terraform.state" key