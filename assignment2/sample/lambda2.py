import json
import boto3

def lambda_handler(event, context):
    # Get text from Lambda 1
    input_text = event.get('text', '')
    appended_text = f"{input_text} -> Lambda2 appended"
    
    # Invoke Lambda 3
    lambda_client = boto3.client('lambda')
    response = lambda_client.invoke(
        FunctionName='lambda-function-3',
        InvocationType='RequestResponse',
        Payload=json.dumps({'text': appended_text})
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Lambda 2 completed and invoked Lambda 3')
    }