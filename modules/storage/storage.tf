resource "google_storage_bucket" "storage-bucket" {
    name = "my-storage-bucket"
    location = "US"
    storage_class = "STANDARD"
    force_destroy = true
}