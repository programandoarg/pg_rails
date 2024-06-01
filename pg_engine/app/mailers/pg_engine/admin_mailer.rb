module PgEngine
  class AdminMailer < ApplicationMailer
    # default delivery_method: :smtp

    def admin_mail
      mail
    end
  end
end
