json.extract! order, :id, :stripe_checkout_session_id, :store_id, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
