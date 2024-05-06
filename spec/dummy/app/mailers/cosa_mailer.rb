class CosaMailer < ApplicationMailer
  def cosa
    @cosa = params[:cosa]
    @email = Email.create(
      from_name: @cosa.nombre,
      from_address: 'testing@facturabien.com.ar',
      to: 'mrosso10@gmail.com',
      subject: 'La cosa por mail',
      associated: @cosa
    )
    # @body = params[:body]

    # unless @comprobante.estado_emision.emitido?
    #   raise PgEngine::BaseMailer::MailNotDelivered, 'el comprobante no está emitido'
    # end

    attachments["cosa_#{@cosa.id}.json"] = @cosa.to_json

    # @tracking_ref = @comprobante.hashid

    mail
  end
end
