output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets_id" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "private_subnets_id" {
  value = "${aws_subnet.private_subnet.*.id}"
}

output "security_groups_ids" {
  value = [aws_security_group.sshhttps.id, aws_security_group.http_only.id]
}

output "public_route_table" {
  value = "${aws_route_table.public.id}"
}

output "lb_public" {
  value = aws_lb.lb_public
}

output "lb_listener" {
  value = aws_lb_listener.https.arn
}

output "certificate" {
  value = aws_acm_certificate.cert
}

output "zone_id" {
  value = data.aws_route53_zone.defcon.zone_id
}