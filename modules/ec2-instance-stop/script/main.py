import boto3
import os

ec2 = boto3.resource("ec2")

def lambda_handler(event, context):

    # Define the tag to filter by (e.g., Environment: Dev)
    tag = {'Key': 'AutoStop', 'Value': 'True'}

    # Describe instances with the specific tag and in the 'running' state
    instances = ec2.instances.filter(
        Filters=[
            {'Name': 'tag:' + tag['Key'], 'Values': [tag['Value']]},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )

    # Extract instance IDs from the filtered instances
    instances_to_stop = [instance.id for instance in instances]
    if instances_to_stop:
        # Stop the filtered instances
        ec2_client = boto3.client('ec2')
        ec2_client.stop_instances(InstanceIds=instances_to_stop)
        print(f"Stopping instances: {instances_to_stop}")
    else:
        print("No running instances found with the specified tag.")

    return {"stopped_instances": instances_to_stop}

if __name__ == "__main__":
    event = {"local_mode": True}
    lambda_handler(event, None)
