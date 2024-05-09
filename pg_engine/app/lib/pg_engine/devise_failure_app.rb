# frozen_string_literal: true

require 'devise'

module PgEngine
  # Checks the scope in the given environment and returns the associated failure app.
  class DeviseFailureApp < Devise::FailureApp
    def respond
      if warden_message == :unconfirmed
        # FIXME: testear
        render_unconfirmed
      else
        super
      end
    end

    private

    def user_email
      params[:user][:email]
    rescue StandardError => e
      pg_warn e, :warn
    end

    def render_unconfirmed
      self.content_type = 'text/vnd.turbo-stream.html'
      self.status = 200
      self.response_body = <<~HTML
        <turbo-stream action="update" target="flash">
          <template>
            <div class="alert alert-warning d-flex align-items-center">
              <div class="bi bi-exclamation-circle me-3"></div>
              <span>
                Tu cuenta aún no está confirmada.
                <br>
                Revisá tu bandeja de entrada o&nbsp;
                <a href="/users/confirmation/new?email=#{user_email}">hacé click acá para reenviar el correo</a>
              </span>
            </div>
          </template>
        </turbo-stream>
      HTML
    end
  end
end
