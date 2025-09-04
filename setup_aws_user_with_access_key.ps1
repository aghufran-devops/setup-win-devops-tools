# Define the IAM user name
$userName = "eks-s3-dynamo-ecr-ec2-user"

# Create the IAM user
aws iam create-user --user-name $userName

# Define the list of policy ARNs to attach
$policyArns = @(
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
)

# Attach each policy to the user
foreach ($policyArn in $policyArns) {
    aws iam attach-user-policy --user-name $userName --policy-arn $policyArn
}

# Create access keys for the user
$accessKey = aws iam create-access-key --user-name $userName | ConvertFrom-Json
$accessKeyId = $accessKey.AccessKey.AccessKeyId
$secretAccessKey = $accessKey.AccessKey.SecretAccessKey

# Define the .aws directory path (Windows-specific)
$awsDir = Join-Path $env:USERPROFILE ".aws"

# Create the .aws directory if it doesn't exist
if (-not (Test-Path -Path $awsDir)) {
    New-Item -ItemType Directory -Path $awsDir -Force | Out-Null
    attrib +h $awsDir  # Make folder hidden on Windows
}

# Write the config file
$configContent = @"
[default]
region = us-east-1
"@
$configPath = Join-Path $awsDir "config"
$configContent | Set-Content -Path $configPath -Encoding UTF8

# Write the credentials file
$credentialsContent = @"
[default]
aws_access_key_id = $accessKeyId
aws_secret_access_key = $secretAccessKey
"@
$credentialsPath = Join-Path $awsDir "credentials"
$credentialsContent | Set-Content -Path $credentialsPath -Encoding UTF8

# Output confirmation
Write-Host "✅ IAM user '$userName' created and configured successfully."
Write-Host "✅ AWS CLI credentials saved to hidden folder: $awsDir"
Write-Host "✅ You can now run 'aws sts get-caller-identity' to verify access."
