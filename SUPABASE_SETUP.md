# Supabase setup

This connects the GitHub Pages shop to a Supabase product catalog and enables the product editor at `admin.html`.

## Create the project

1. Sign in at [supabase.com/dashboard](https://supabase.com/dashboard) and create a Free project. Choose a database password and save it somewhere private.
2. In the project SQL Editor, paste and run the contents of `supabase-schema.sql`. This creates the products table, security policies, public product-photo bucket, and the current eight products.
3. In the project settings/API page, copy the Project URL and the publishable key (or legacy `anon` key).

## Connect the website

1. Open `supabase-config.js` and fill in `url` and `anonKey` with those two values. Keep `adminEmail` as `elorriii02@gmail.com`.
2. Never put a `service_role` or secret key in this file. The publishable/anon key is intended for browser use; the SQL row-level security policies restrict product changes to the owner email.
3. Commit and push the config change to `main`. GitHub Pages will deploy the connected storefront.

## Create the admin login

1. In Supabase, open Authentication > Users and send an invitation to `elorriii02@gmail.com`. Open the invitation email to finish account setup and choose a password.
2. Open `https://joeg700.github.io/El-Ori-website/admin.html` and sign in with that email and password.
3. Use **New product** to add items, edit details or photos, and archive or restore products.

The Free plan can pause a project after seven days without Supabase activity. Store visits query the product table, which keeps the project active while the shop is being used. Check Supabase's current quotas and pricing before enabling paid usage.
