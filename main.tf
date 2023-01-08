resource "aws_elastic_beanstalk_application" "krakow" {
  name        = var.aws_elastic_beanstalk_application_name
  description = "Sample Test Application"
}

resource "aws_iam_instance_profile" "subject_profile" {
  name = var.aws_iam_role_name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "test_role_new"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ])

  role       = aws_iam_role.role.name
  policy_arn = each.value
}
