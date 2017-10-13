json.extract! user, :id, :name, :lastName, :email, :document, :image, :created_at, :updated_at
json.url user_url(user, format: :json)
