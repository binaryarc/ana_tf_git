# zone 생성
resource "aws_route53_zone" "anaconda" {
  name = "vvasco.site"
}
# # A 레코드 생성
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.anaconda.zone_id
#   name    = "www.vvasco.site"
#   type    = "A"

#   alias {
#     name                   = "k8s-default-anaconda-385579aecb-965638832.ap-northeast-2.elb.amazonaws.com"
#     zone_id                = "ZWKZPGTI48KDX"
#     evaluate_target_health = true
#   }
# }

#CF용 레코드 생성
resource "aws_route53_record" "abc" {
  zone_id = aws_route53_zone.anaconda.zone_id
  name    = "*.vvasco.site"
  type    = "CNAME"
  
  alias {
    name                   = "_73101c104e78198843f2a5252e756b49.vvasco.site."
    zone_id                = "Z00122591SN47Y91LGXRJ"
    evaluate_target_health = true
  }
}


#CF용 레코드 생성
resource "aws_route53_record" "abc1" {
  zone_id = aws_route53_zone.anaconda.zone_id
  name    = "abc.vvasco.site"
  type    = "CNAME"
  
  alias {
    name                   = "*.vvasco.site"
    zone_id                = "Z00122591SN47Y91LGXRJ"
    evaluate_target_health = true
  }
}