resource "aws_elb" "lb" {
  name_prefix = "${var.environment}-"
  subnets = ["${aws_subnet.pub-web-az-a.id}", "${aws_subnet.pub-web-az-b.id}"]
  health_check {
    healthy_threshold = 2
    interval = 0
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  cross_zone_load_balancing = true
  instances = ["${aws_instance.WEBA.id}", "${aws_instance.WEBB.id}"]
  security_groups = ["${aws_security_group.LoadBalancerSG.id}"]
}