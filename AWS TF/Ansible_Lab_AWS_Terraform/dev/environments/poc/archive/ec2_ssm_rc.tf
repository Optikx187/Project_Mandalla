################################################################################
# ssm resource
################################################################################
#windows
resource aws_ssm_document windows_script {
  name          = "${var.ssm_win_config_name}"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "execute simple powershell",
    "parameters": {
        "sampleParam" :{
         "type": "String",
         "description": "Example parameter",
         "default": "Hello World"
        }
    },
    "mainSteps":[
        {
            "action" : "aws:runPowerShellScript",
            "name"   : "ps_script",
            "inputs" : {
                "runCommand": [
                    "powershell.exe -executionpolicy bypass 'get-date > c:\\thing.txt'"
                ]
            }
        }
    ]
  }
DOC
}
#https://docs.aws.amazon.com/systems-manager/latest/userguide/document-schemas-features.html
resource aws_ssm_association windows_script {
  name = aws_ssm_document.windows_script.name

  targets {
    key    = "tag:${var.ssm_boot}"
    values = ["${var.win_configure_service_1}"]
  }
}


#linux
resource aws_ssm_document rhel_script {
  name          = "${var.ssm_lin_config_name}"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "execute simple shell",
    "parameters": {
        "sampleParam" :{
         "type": "String",
         "description": "Example parameter",
         "default": "Hello World"
        }
    },
    "mainSteps":[
        {
            "action" : "aws:runShellScript",
            "name"   : "shell_script",
            "inputs" : {
                "runCommand": [
                    "touch /tmp/test_ssm_file.bam"
                ]
            }
        },
        {
            "action" : "aws:runShellScript",
            "name"   : "shell_script1",
            "inputs" : {
                "runCommand": [
                    "touch /tmp/test_ssm_file_2.bam"
                ]
            }
        }
    ]
  }
DOC
}
#https://docs.aws.amazon.com/systems-manager/latest/userguide/document-schemas-features.html
resource aws_ssm_association rhel_script {
  name = aws_ssm_document.rhel_script.name

  targets {
    key    = "tag:${var.ssm_boot}"
    values = ["${var.lin_configure_service_1}"]
  }
}