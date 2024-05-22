class CosaMailer < ApplicationMailer
  def cosa
    @cosa = params[:cosa]
    @email_object = Email.create(
      from_name: @cosa.nombre,
      from_address: 'testing@example.com.ar',
      to: 'example@example.org',
      subject: 'La cosa por mail',
      associated: @cosa
    )

    raise PgEngine::BaseMailer::MailNotDelivered, 'falló el mailer' if params[:should_raise_error]

    @body = <<~DOC
      multi
           line

      <script>alert("aaa")</script>

        fin
    DOC

    attachments["cosa_#{@cosa.id}.json"] = @cosa.to_json

    mail
  end

  def cosa_sin_email_object(to)
    raise PgEngine::BaseMailer::MailNotDelivered, 'falló el mailer' if params[:should_raise_error]

    if to.present?
      mail(to:)
    else
      mail
    end
  end
end
