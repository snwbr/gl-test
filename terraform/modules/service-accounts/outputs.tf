output "service_account_names" {
  value = google_service_account.sa.*.name
}

output "service_account_emails" {
  value = google_service_account.sa.*.email
}

