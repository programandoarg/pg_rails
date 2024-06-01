Rails.application.configure do
  config.turbo.signed_stream_verifier_key = 'turbostream-secret-test'
end
CableReady.config.verifier_key = 'cableready-secret-test'
AnyCable.config.jwt_id_key = 'jwt-secret-test'
