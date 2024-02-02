#!/usr/local/bin/bash

# Default to dev environment if not specified
ENV=${1:-dev}

# Load environment variables from specified .env file
ENV_FILE=".env.$ENV"
if [ -f "$ENV_FILE" ]; then
    while IFS='=' read -r key value
    do
        if [[ -n $key && -n $value ]]; then
            export "$key=$value"
        fi
    done < "$ENV_FILE"
else
    echo "$ENV_FILE not found!"
    exit 1
fi

declare -a IMAGE_REPOSITORIES=()
declare -a PARAMETER_OVERRIDES=()

# Define an associative array for function names
declare -A FUNCTION_NAMES=()
FUNCTION_NAMES["ProcessLambda"]=$ProcessLambda



# Function to get the latest tag of a repository UNCOMMENT WHEN ECR IS SET UP AND UNCOMMENT THE FUNCTION
#get_latest_tag() {
#    local repo_name=$1
#    local latest_tag=$(aws ecr describe-images \
#                        --repository-name "$repo_name" \
#                        --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' \
#                        --output text)
#
#    if [ "$latest_tag" = "None" ]; then
#        echo "No images found in ECR repository $repo_name"
#        latest_tag="latest"
#        return 1
#    fi
#
#    echo "$latest_tag"
#}


# Iterate over the function names
for var in "${!FUNCTION_NAMES[@]}"; do
#    repo_name=${FUNCTION_NAMES[$var]} UNCOMMENT WHEN ECR IS SET UP AND DELETE NEXT LINE
    repo_name="docker_image"
#    latest_tag=$(get_latest_tag "$repo_name") UNCOMMENT WHEN ECR IS SET UP AND DELETE NEXT LIN
    latest_tag="latest"

    if [ $? -eq 0 ]; then
        repo_url="$AWS_ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$repo_name:$latest_tag"
        # Enclose entire repo_url in quotes
        IMAGE_REPOSITORIES+=("\"$var=$repo_url\"")
        # Enclose each parameter override in quotes
        PARAMETER_OVERRIDES+=("${var}"ImageUri="$repo_url")
    fi
done

# Static parameters
STATIC_PARAMS=(
    "VpcCidrBlock=10.0.0.0/16"
    "PublicSubnetCidrBlock=10.0.1.0/24"
    "PrivateSubnetCidrBlock=10.0.2.0/24"
    "RoutesDestinationCidrBlock=0.0.0.0/0"
    "LogLevel=INFO"
    "Environment=$ENV"
    "ProjectName=$PROJECT_NAME"

)

STACK_NAME="$PROJECT_NAME-$ENV"
S3_BUCKET="$PROJECT_NAME-samclisourcebucket-$ENV"
S3_PREFIX="$PROJECT_NAME-data-$ENV"

# Append static parameters to PARAMETER_OVERRIDES
for param in "${STATIC_PARAMS[@]}"; do
    PARAMETER_OVERRIDES+=("$param")
done

# Construct the lists for sam deploy
# Join array elements with a comma for both parameter overrides and image repositories
PARAMETER_OVERRIDES_LIST=$(IFS=" "; echo "${PARAMETER_OVERRIDES[*]}")
IMAGE_REPOS_LIST=$(IFS=,; echo "${IMAGE_REPOSITORIES[*]}")


cp samconfig.temp.toml samconfig.toml
sed -i '' "s|\[\"IMAGE_REPOS_LIST_$ENV\"\]|\[$IMAGE_REPOS_LIST\]|g" samconfig.toml
sed -i '' "s|STACK-NAME-$ENV|$STACK_NAME|g" samconfig.toml
sed -i '' "s|samclisourcebucket-$ENV|$S3_BUCKET|g" samconfig.toml
sed -i '' "s|prefix-$ENV|$S3_PREFIX|g" samconfig.toml
sed -i '' "s|region|$REGION|g" samconfig.toml
sed -i '' "s|PARAMS_OVERIDE_$ENV|$PARAMETER_OVERRIDES_LIST|g" samconfig.toml


# Now you can run sam deploy
#sam deploy