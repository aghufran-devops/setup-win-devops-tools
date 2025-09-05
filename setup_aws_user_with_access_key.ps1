# Define the IAM user name
$userName = "eks-s3-dynamo-ecr-ec2-user"

# Create the IAM user
aws iam create-user --user-name $userName

# Define the list of AWS managed policy ARNs to attach
$policyArns = @(
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
)

# Attach each managed policy to the user
foreach ($policyArn in $policyArns) {
    aws iam attach-user-policy --user-name $userName --policy-arn $policyArn
}

# Create access keys for the user
$accessKey = aws iam create-access-key --user-name $userName | ConvertFrom-Json
$accessKeyId = $accessKey.AccessKey.AccessKeyId
$secretAccessKey = $accessKey.AccessKey.SecretAccessKey

# Define the custom inline policy
$customPolicy = @"
{
  \"Version\": \"2012-10-17\",
  \"Statement\": [
    {
      \"Effect\": \"Allow\",
      \"Action\": \"ssm:GetParameter\",
      \"Resource\": \"arn:aws:ssm:us-east-1::parameter/aws/service/ami-amazon-linux-latest/*\"
    }
  ]
}
"@

# Attach the inline policy to the user
aws iam put-user-policy `
    --user-name $userName `
    --policy-name "AllowSSMParameterAccess" `
    --policy-document $customPolicy

# Get the current user's Downloads folder
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$csvFileName = "aws_access_keys_$userName.csv"
$csvPath = Join-Path $downloadsPath $csvFileName

# Prepare CSV content
$csvContent = @()
$csvContent += "AccessKeyId,SecretAccessKey"
$csvContent += "$accessKeyId,$secretAccessKey"

# Write to CSV file
$csvContent | Set-Content -Path $csvPath -Encoding UTF8

# Output confirmation
Write-Host "IAM user '$userName' created."
Write-Host "Access keys exported to: $csvPath"
