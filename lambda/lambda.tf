locals {
  function_name = "my_lambda_function"
}

data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = "app"
  output_path = "archive/my_lambda_function.zip"
}

resource "aws_lambda_function" "function" {
  function_name = local.function_name
  handler       = "lambda.handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"

  kms_key_arn = aws_kms_key.lambda_key.arn

  filename         = data.archive_file.function_source.output_path
  source_code_hash = data.archive_file.function_source.output_base64sha256

  environment {
    variables = {
      BASE_MESSAGE = "Hello"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy, aws_cloudwatch_log_group.lambda_log_group]
}
