# resource "aws_cloudfront_distribution" "anaconda" {
#   origin {
#     domain_name = "k8s-default-anaconda-385579aecb-1523845944.ap-northeast-2.elb.amazonaws.com"
#     origin_id = "k8s-default-anaconda-385579aecb-1523845944.ap-northeast-2.elb.amazonaws.com"

#     custom_origin_config {
#       http_port = "80"
#       https_port = "443"
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#     }
#   }

#   enabled = true
#   default_root_object = "index.html"

#   default_cache_behavior {
#     viewer_protocol_policy = "redirect-to-https"
#     compress = true
#     allowed_methods = ["GET", "HEAD","OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
#     cached_methods = ["GET", "HEAD"]
#     target_origin_id = "k8s-default-anaconda-385579aecb-1523845944.ap-northeast-2.elb.amazonaws.com"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn = "arn:aws:acm:us-east-1:158040193241:certificate/612ef101-def6-467c-8759-d5611802bbd8"
#     ssl_support_method = "sni-only"
#   }
# }


#test
resource "aws_cloudfront_distribution" "anaconda2" {
  origin {
    domain_name = "k8s-default-anaconda-385579aecb-965638832.ap-northeast-2.elb.amazonaws.com"
    origin_id = "k8s-default-anaconda-385579aecb-965638832.ap-northeast-2.elb.amazonaws.com"

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  # default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET", "HEAD","OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "k8s-default-anaconda-385579aecb-965638832.ap-northeast-2.elb.amazonaws.com"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:158040193241:certificate/ba99fbe6-b6e4-41b5-8846-23fc9ce6e4e6"
    ssl_support_method = "sni-only"
  }
  
  aliases = ["*.vvasco.site"]
}