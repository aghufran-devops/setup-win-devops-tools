# Define the IAM user name and profile name
$userName = "eks-s3-dynamo-ecr-ec2-user"
$profileName = "igp-profile"

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

# Configure the new profile using aws configure set
aws configure set aws_access_key_id $accessKeyId --profile $profileName
aws configure set aws_secret_access_key $secretAccessKey --profile $profileName
aws configure set region us-east-1 --profile $profileName
aws configure set output json --profile $profileName

# Output confirmation
Write-Host "✅ IAM user '$userName' created."
Write-Host "✅ Profile '$profileName' configured using aws CLI."
Write-Host "✅ You can now use: aws sts get-caller-identity --profile $profileName"
