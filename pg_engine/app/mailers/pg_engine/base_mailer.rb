module PgEngine
  class BaseMailer < ActionMailer::Base
    class MailNotDelivered < StandardError; end

    before_action { @from_name = params[:from_name] }

    default from: -> { email_address_with_name(ENV.fetch('DEFAULT_MAIL_FROM'), @from_name) },
            reply_to: -> { params[:reply_to] },
            subject: -> { params[:subject] },
            to: -> { params[:to] }

    layout 'pg_layout/mailer'

    rescue_from MailNotDelivered do |err|
      # FIXME: marcar el Email en la DB como fallido
      pg_err err
    end
  end
end

=begin
  # TODO: testear
      si from está vacío
      si body está vacío
      si se lanza PgEngine::BaseMailer::MailNotDelivered
