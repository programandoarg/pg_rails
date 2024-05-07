module PgEngine
  class BaseMailer < ActionMailer::Base # rubocop:disable Rails/ApplicationMailer
    class MailNotDelivered < StandardError; end

    before_action { @email = params[:email] }

    default from: -> { email_address_with_name(@email.from_address, @email.from_name) },
            reply_to: -> { @email.reply_to },
            subject: -> { @email.subject },
            to: -> { @email.to }

    layout 'pg_layout/mailer'

    # default delivery_method: :smtp

    # TODO: rescue from StandardError? from PgEngine::Error?

    rescue_from MailNotDelivered do |err|
      # FIXME: marcar el Email en la DB como fallido
      pg_err err
    end

    protected

    def mail(*args)
      super(*args).tap do |message|
        # message.mailgun_options = {
        #   'tag' => email.tags,
        #   'tracking-opens' => true
        # }
        message['email'] = @email
      end
    end
  end
end

#   # TODO: testear
#       si from está vacío
#       si body está vacío
#       si se lanza PgEngine::BaseMailer::MailNotDelivered
