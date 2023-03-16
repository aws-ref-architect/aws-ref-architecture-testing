resource "aws_wafv2_web_acl" "game_bucket_privacy" {
  name  = "game_bucket_privacy"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "ip-whitelist"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_whitelist.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "whitelist-ip"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "game-metrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "ip_whitelist" {
  name               = "ip_whitelist"
  description        = "List of IPs that can access game bucket."
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["3.121.56.176"]
}

resource "aws_cloudfront_distribution" "game_distribution" {
  origin {
    domain_name              = "aws_s3_bucket.${var.bucket_name}.bucket_regional_domain_name"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.log_bucket.id
    prefix          = "waf"
  }
}
