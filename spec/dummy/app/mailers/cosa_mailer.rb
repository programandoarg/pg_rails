class CosaMailer < ApplicationMailer
  def cosa
    @cosa = params[:cosa]
    @email = Email.create(
      from_name: @cosa.nombre,
      from_address: 'testing@example.com.ar',
      to: 'example@example.org',
      subject: 'La cosa por mail',
      associated: @cosa
    )

    raise PgEngine::BaseMailer::MailNotDelivered, 'falló el mailer' if params[:raise_error]

    @body = <<~DOC
      multi
           line

      <script>alert("aaa")</script>

        fin
    DOC

    attachments["cosa_#{@cosa.id}.json"] = @cosa.to_json

    mail
  end
end
