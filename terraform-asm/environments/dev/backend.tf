terraform {
  backend "gcs" {
    bucket  = "kpt-bootstrap-001"
    prefix  = "tfstate"
  }
}
