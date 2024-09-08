resource "aws_lambda_layer_version" "common_layer" {
  filename   = "${path.module}/../../../python-request-layer-sp.zip"
  layer_name = "requests_layer"
  description = "Common layer with shared libraries"
  compatible_runtimes = ["python3.12"]

  source_code_hash = filebase64sha256("${path.module}/../../../python-request-layer-sp.zip")
}
