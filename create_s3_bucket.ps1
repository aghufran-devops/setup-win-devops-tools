# PowerShell Script to Create an S3 Bucket for Terraform Remote Backend with Error Handling

$bucketName = "igp-terraform-remote-backend-s3"
$region = "us-east-1"

# Try to create the S3 bucket
try {
    $createResponse = aws s3api create-bucket --bucket $bucketName --region $region

    Write-Host "Bucket '$bucketName' created successfully."

    # Enable versioning
    try {
        aws s3api put-bucket-versioning --bucket $bucketName --versioning-configuration Status=Enabled

        Write-Host "Versioning enabled for bucket '$bucketName'."
    }
    catch {
        Write-Host "Failed to enable versioning: $_"
    }
}
catch {
    Write-Host "Failed to create bucket: $_"
}
