# config/initializers/stripe.rb
Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # Make sure to set this in your environment variables
