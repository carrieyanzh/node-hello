
terraform {
  required_providers {

    docker={
        source  = "kreuzwerker/docker"
        version = "~> 3.0"

    }


     
}
}


resource "docker_image" "node_hello" {
  name = "node-hello"
  build {
    context = "${path.module}/."
  }
}

resource "docker_container" "node_hello" {
  name  = "node-hello"
  image = docker_image.node_hello.name

  ports {
    internal = 3000
    external = 3000
  }
}
