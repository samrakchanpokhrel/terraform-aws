resource "aws_cloudwatch_dashboard" "demo-dashboard" {
  dashboard_name = "demo-dashboard-${var.ec2-instance}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${var.ec2-instance}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "${var.ec2-instance} - CPU Utilization"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 7
        width  = 3
        height = 3

        properties = {
          markdown = "My Demo Dashboard"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${var.ec2-instance}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "${var.ec2-instance} - NetworkIn"
        }
      }
    ]
  })
}
