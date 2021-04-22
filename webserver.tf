// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "webserver" {
 name         = "webserver-${var.appname}"
 machine_type = "n1-standard-2"
 zone         = "us-central1-a"
 allow_stopping_for_update = true
 tags = ["http-server", "https-server"]

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-10"
   }
 }

 // Install some basic software
 metadata_startup_script = "sudo apt-get update && apt-get install -y git nginx"

 network_interface {
   network = "vpc-dev"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }

 #metadata = {
 #  ssh-keys = "jump:${file("~/.ssh/jump.pub")}"
 #}
}

// A variable for extracting the external IP address of the instance
output "ip" {
 value = google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip
}



