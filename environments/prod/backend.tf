terraform {
  backend "s3" {
    bucket         = "backend-prod"
    key            = "prod.tfstate"
    region         = "us-east-2"
    #dynamodb_table = "terraform-locks-prod"
    use_lockfile   = true
    encrypt        = true
  }
}