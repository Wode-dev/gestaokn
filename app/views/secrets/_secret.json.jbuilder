json.extract! secret, :id, :name, :address, :city, :state, :neighborhood, :doc_name, :doc_value, :secret, :secret_password, :wireless_ssid, :wireless_password, :due_date, :plan_id, :created_at, :updated_at
json.url secret_url(secret, format: :json)
