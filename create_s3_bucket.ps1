
# PowerShell Script to Create an S3 Bucket for Terraform Remote Backend

# Set the bucket name
$bucketName = "igp-terraform-remote-backend-s3"
$region = "us-east-1"  # Change to your preferred AWS region

# Create the S3 bucket
aws s3api create-bucket `
    --bucket $bucketName `
    --region $region `
    --create-bucket-configuration LocationConstraint=$region

# Enable versioning (recommended for Terraform backend)
aws s3api put-bucket-versioning `
    --bucket $bucketName `
    --versioning-configuration Status=Enabled

Write-Host "S3 bucket '$bucketName' created and versioning enabled."
