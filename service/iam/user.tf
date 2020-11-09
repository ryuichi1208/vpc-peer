resource "aws_iam_user" "example_exp" {
  count         = "${length(var.aws_iam_user)}"
  name          = "${element(var.aws_iam_user, count.index)}"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "example_exp_login_profile" {
  count                   = "${length(var.aws_iam_user)}"
  user                    = "${element(var.aws_iam_user, count.index)}"
  pgp_key                 = "keybase:exp_example"
  password_reset_required = true
  password_length         = "20"
}

resource "aws_iam_access_key" "example_exp_access_key" {
  count   = "${length(var.aws_iam_user)}"
  user    = "${element(var.aws_iam_user, count.index)}"
  pgp_key = "keybase:exp_example"
}

output "encrypted_secret" {
  value = "${join("\n", aws_iam_access_key.example_exp_access_key.*.encrypted_secret)}"
}

output "id" {
  value = "${join("\n", aws_iam_access_key.example_exp_access_key.*.id)}"
}

output "user" {
  value = "${join("\n", aws_iam_access_key.example_exp_access_key.*.user)}"
}
