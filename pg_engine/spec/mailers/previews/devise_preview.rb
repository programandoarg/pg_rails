# Preview all emails at http://localhost:3000/rails/mailers/cliente
class DevisePreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/cliente/comprobante_recibido
  def confirmation_instructions
    # ClienteMailer.comprobante_recibido(VComprobante.find(params[:]))
    Devise::Mailer.confirmation_instructions(User.first, 'TOKENN')
  end

  def reset_password_instructions
    # ClienteMailer.comprobante_recibido(VComprobante.find(params[:]))
    Devise::Mailer.reset_password_instructions(User.first, 'TOKENN')
  end
end
