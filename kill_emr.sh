#!/bin/bash

# Get the cluster ID
cluster_id=$(aws emr list-clusters --cluster-states WAITING --query 'Clusters[0].Id' --output text)

# Check if cluster_id is None or empty
if [[ -z $cluster_id || $cluster_id == "None" ]]; then
    echo "Did not find a waiting EMR cluster. Exiting..."
    exit 1
fi

# Get the cluster creation time
creation_time=$(aws emr describe-cluster --cluster-id "$cluster_id" --query 'Cluster.Status.Timeline.CreationDateTime' --output text)

# Check if creation_time is None or empty
if [[ -z $creation_time || $creation_time == "None" ]]; then
    echo "Invalid cluster ID. Exiting..."
    exit 1
fi

# Calculate the elapsed time in seconds
current_time=$(date +%s)
creation_time_seconds=$(date -d "$creation_time" +%s)
elapsed_time=$((current_time - creation_time_seconds))

# Terminate the cluster if it has been waiting for more than 1 hour (3600 seconds)
if [[ $elapsed_time -gt 3600 ]]; then
    echo "Terminating cluster $cluster_id"
    aws emr terminate-clusters --cluster-ids "$cluster_id"
else
    echo "Cluster $cluster_id has not been waiting for more than 1 hour"
fi
