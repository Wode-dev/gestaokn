json.extract! record, :id, :name, :address, :city, :state, :neighborhood, :phone, :notes, :created_at, :updated_at
json.url record_url(record, format: :json)
