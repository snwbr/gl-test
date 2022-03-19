terraform {
  backend "gcs" {
    bucket      = "snwbr-tf-state"
    prefix      = "projects"
    credentials = "../../terraform-sa.json"
  }
}
