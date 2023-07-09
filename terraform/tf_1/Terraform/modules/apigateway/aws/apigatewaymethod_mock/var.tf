variable "apigateway_id" {}
variable "resource_id" {}
variable "authorization" {
    default = "NONE"
}
variable authorizer_id {
     default = ""
}
variable "http_method" {
  default = "OPTIONS"
}
variable "http_method_response"{
  default = "OPTIONS"
}