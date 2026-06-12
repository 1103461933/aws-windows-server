terraform {
  backend "s3" {
    bucket         = "backend-dev-911"
    key            = "dev.tfstate"
    region         = "us-east-2"
    #dynamodb_table = "terraform-locks"
    use_lockfile   = true
    encrypt        = true
  }
}