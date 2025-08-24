import json
import boto3

def lambda_handler(event, context):
    # Process initial input
    input_text = event.get('text', 'Hello')
    processed_text = f"Lambda1 processed: {input_text}"
    
    # Invoke Lambda 2
    lambda_client = boto3.client('lambda')
    response = lambda_client.invoke(
        FunctionName='lambda-function-2',
        InvocationType='RequestResponse',
        Payload=json.dumps({'text': processed_text})
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Lambda 1 completed and invoked Lambda 2')
    }