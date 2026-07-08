resource "cloudflare_account_token" "terraform_token" {
  account_id = "8affe8f9f16e8e087289519c2a64d0ce"
  name       = "terraform"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = "82e64a83756745bbbb1c9c2701bf816b"
      }, {
      id = "4755a26eedb94da69e1066d98aa820be"
    }]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.1736d39b12f74b1eeea52ed2c203c91e" = "*"
    })
  }]
}