resource "google_storage_bucket" "trigger" {
  name     = "performance-trigger"
  location = "asia-northeast1"
}

resource "google_storage_bucket_object" "trigger" {
  name   = "trigger.zip"
  bucket = "${google_storage_bucket.trigger.name}"
  source = "../output/trigger.zip"
}

data "archive_file" "trigger" {
  type        = "zip"
  output_path = "../output/trigger.zip"
  source_dir  = "../src/trigger"
}

resource "google_cloudfunctions_function" "function" {
  name        = "performance-trigger"
  description = "hello world"
  runtime     = "nodejs8"

  available_memory_mb   = 128
  source_archive_bucket = "${google_storage_bucket.trigger.name}"
  source_archive_object = "${google_storage_bucket_object.trigger.name}"
  timeout               = 10
  entry_point           = "helloGET"
  trigger_http          = true
}
