terraform {
  backend "gcs" {
    bucket  = "mbychkowski-lab"
    prefix  = "tfstate"
  }
}
