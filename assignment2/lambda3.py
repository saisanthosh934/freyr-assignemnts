import json

def lambda_handler(event, context):
    # Get final text from Lambda 2
    final_text = event.get('text', '')
    result = f"{final_text} -> Lambda3 final result"
    
    # Print results
    print(f"FINAL RESULT: {result}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Processing complete',
            'final_result': result
        })
    }