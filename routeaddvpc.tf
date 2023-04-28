resource "aws_route53_zone_association" "secondary" {
  zone_id = "Z01817288AYQJ8IWO87B"
  vpc_id  =  aws_vpc.main.id
}