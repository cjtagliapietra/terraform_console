variable "instancias" {
  type = list(map(string))
  default = [ 
    {
      hostname: "ec2-1", 
      ip_address: "10.0.0.10"
    },
    {  
      hostname: "ec2-2", 
      ip_address: "10.0.0.20"
    } 
  ]
}

variable "types" {
  type = map(string)
   default = {
     "ec2-1": "t3.medium",
     "ec2-2": "t3.xlarge"
   }
}

locals {
  user-data = <<EOT
%{ for instance in var.instancias ~}
Hostname=${instance.hostname} 
IpAAddress=${instance.ip_address}:8080
%{ endfor }
EOT
}

# resource "template_file" "my-template" {
#   template = file("notas.txt")
# }

# resource "aws_instance" "web" {
#   ami           = var.instancias.0.hostname
#   instance_type = var.types[var.instancias.0.hostname]

#   tags = {
#     Name = "HelloWorld"
#   }
# }