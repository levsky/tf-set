output "vpc_id" {
    value = "${aws_vpc.k8s.id}"
    description = "VPC ID"
}

output "kops_s3_bucket" {
    value = "${var.kops-s3-bucket}"
    description = "FQDN of bucket"
}


output "public_dns_zone_id" {
    value = "${aws_route53_zone.public.id}"
    description = "DNS Zone ID"
}

output "vpc_cidr" {
    value = "${var.vpc-cidr}"
    description = "VPC Network CIDR"
}


//output "private_dns_zone_id" {
  //  value = "${aws_route53_zone.private.id}"
  //  description = "DNS Zone ID"
//}
