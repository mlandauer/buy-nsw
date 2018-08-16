# Rake tasks

There are a small number of application-specific Rake tasks, which we have documented below.

Task | Description
--- | ---
`rake app:sellers:create:fake` | Uses `Faker` to replace your database with randomly generated example sellers.
`rake app:sellers:import:csv` | Replaces your sellers and products with data imported from `exported_sellers.csv` and `exported_products.csv`
`rake app:sellers:export:csv` | Exports all sellers and products to `exported_sellers.csv` and `exported_products.csv`
`rake app:users:make_admin[<email>]` | Gives the nominated user account the `admin` role
