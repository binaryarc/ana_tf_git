
#create role
resource "aws_iam_role" "codebuild_role_was" {
  name = "ana_test_codebuild_role_was"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#Create policy to link
resource "aws_iam_role_policy" "codebuild_role_policy" {
  role = aws_iam_role.codebuild_role_was.name
#Policy for viewing log
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

#no need, setting github access token
# resource "aws_codebuild_source_credential" "ana_codebuild_cred" {
#   auth_type   = "PERSONAL_ACCESS_TOKEN"
#   server_type = "GITHUB"
#   token       = "gitaccesstoken"
# }

resource "aws_codebuild_project" "ana_cb_proj" {
  #Required
  #build project name, to be used role
  name          = "ana_test_codebuild_project"
  description   = "test_codebuild_project"
  #Required
  service_role  = aws_iam_role.codebuild_role_was.arn
  #Required
  #output artifacts setting
  artifacts {
    type = "NO_ARTIFACTS"
  }
  #Required
  #build environment
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    #권한 승격 Privilege escalation
    privileged_mode = true
    

    #environment variables to be used
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "SOME_VALUE2"
    }
    
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "SOME_VALUE2"
    }
    
    environment_variable {
      name  = "IMAGE_TAG"
      value = "SOME_VALUE2"
    }
    
    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = "SOME_VALUE2"
    }
    
    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = "SOME_VALUE2"
    }
  }
  
  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }
  #Required
  #setting github url, buildspec, auth 
  source {
    type            = "GITHUB"
    location        = "https://github.com/jin4363/ana_was_git.git"
    git_clone_depth = 1
    buildspec="buildspec.yml"
    auth {
    type = "OAUTH"
    #   resource = "aws_codebuild_source_credential.ana_codebuild_cred.id"
    }
    # git_submodules_config {
    #   fetch_submodules = true
    # }
  }

  source_version = "main"

}

#webhook setting , github push event > build
resource "aws_codebuild_webhook" "ana_cb_webhook" {
  project_name = aws_codebuild_project.ana_cb_proj.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

  }
}
