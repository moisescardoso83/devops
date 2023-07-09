resource "aws_instance" "example" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  user_data     = var.user_data

  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.name
  }

  # Configurações do mercado spot
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = var.spot_price
    }
  }
}