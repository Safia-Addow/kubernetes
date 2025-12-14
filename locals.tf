locals {
  name   = "eks-lab"
  domain = "lab.safiaaddow.uk"
  region = "eu-west-2" # London region


  tags = {
    Enviroment = "sandbox"
    projects   = "EKS Advanced Lab"
    owner      = "Safia"
  }
}