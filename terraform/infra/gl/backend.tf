terraform {
  backend "gcs" {
    bucket      = "snwbr-tf-state"
    prefix      = "gl-challenge"
    credentials = "../../terraform-sa.json"
  }
}
