OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1982117412032482', '38a3033009fff45f76e143a3891c77e4', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end