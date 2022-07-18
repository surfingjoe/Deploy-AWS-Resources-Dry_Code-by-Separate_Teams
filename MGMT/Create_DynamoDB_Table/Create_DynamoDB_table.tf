provider "aws" {
  region = "<your_region>"
}
# ----------  Create DynamoDB for Locking S3 state ------------------
resource "aws_dynamodb_table" "test" { 
  name = "test_db_locks" 
  billing_mode = "PAY_PER_REQUEST" 
  hash_key = "LockID" 
  attribute {
     name = "LockID" 
     type = "S" 
     } 
} 