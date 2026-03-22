provider "google"{
    credentials = file("C:/Users/ashok/Downloads/my-project-1-486406-0396773d2982.json")
    project_Id = "my-project-1-486406"
    region = var.region
    zone = var.zone
}