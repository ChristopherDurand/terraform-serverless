data "archive_file" "lambda_files" {
  for_each    = var.lambdas
  type        = "zip"
  source_file = "${path.root}/../functions/${each.key}.js"
  output_path = "${path.root}/.funcs/${each.key}.zip"
}

