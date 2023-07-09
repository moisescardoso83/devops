output "aws_alb" {
  value = aws_alb.this.arn
}

output "aws_alb_sg" {
  value = aws_security_group.alb-sg.arn
}

output "aws_alb_sg_id" {
  value = aws_security_group.alb-sg.id
}
