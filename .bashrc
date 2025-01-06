function gap(){
    git add .  && git commit -m "$1" && git push
}

#!/bin/bash

# Function to build, stop, remove, and run a Docker container
#  docker build image, 
function dboard() {
    local name=$1          # Mandatory: Image/Container Name
    local primary_port=$2  # Mandatory: Primary Port
    local secondary_port=$3 # Optional: Secondary Port

    # Check for mandatory parameters
    if [[ -z "$name" || -z "$primary_port" ]]; then
        echo "Usage: docker_dashboard <name> <primary_port> [secondary_port]"
        return 1
    fi

    # Determine the port to use
    local port_mapping="${primary_port}:${primary_port}"
    if [[ -n "$secondary_port" ]]; then
        port_mapping="${secondary_port}:${primary_port}"
    fi

    echo "Building Docker image '${name}'..."
    docker build -t "$name" .

    echo "Stopping any running container named '${name}'..."
    docker stop "$name" 2>/dev/null

    echo "Removing any existing container named '${name}'..."
    docker rm "$name" 2>/dev/null

    echo "Running container '${name}' with port mapping ${port_mapping}..."
    docker run -d -p $port_mapping --name "$name" "$name"

    echo "Container '${name}' is now running."
}

# Example usage:
# docker_dashboard my_dashboard 6003
# docker_dashboard my_dashboard 6003 7000


#!/bin/bash

# Function to stop/remove containers and remove image
function cleandocker() {
    name=$1

    # Check if container name is provided
    if [ -z "$name" ]; then
        echo "Error: No container name provided."
        exit 1
    fi

    # Check if image name is provided
    if [ -z "$name" ]; then
        echo "Error: No image name provided."
        exit 1
    fi

    # Stop and remove container
    echo "Stopping container: $name"
    docker stop $name

    echo "Removing container: $name"
    docker rm $name

    # Remove image
    echo "Removing image: $name"
    docker rmi $name

    echo "Cleanup complete: Container '$name' and Image '$name' removed."
}

# Check if enough arguments were passed
# if [ $# -lt 2 ]; then
#     echo "Usage: $0 <name>  define the container name"
#     exit 1
# fi

# Call cleanup function with parameters

