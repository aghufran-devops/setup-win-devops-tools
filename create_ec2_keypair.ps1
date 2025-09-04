
$KeyName = "IGPKeyPair"
$OutputFile = "$KeyName.pem"

# Create the key pair and save the private key to a .pem file
aws ec2 create-key-pair --key-name $KeyName --query "KeyMaterial" --output text > $OutputFile

# Set the file to read-only
attrib +R $OutputFile

Write-Host "Key pair $KeyName created and saved to $OutputFile"
