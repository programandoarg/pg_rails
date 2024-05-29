module PgEngine
  module EmailsHelper
    def email_status_badge_class(email)
      {
        'pending' => 'text-bg-warning',
        'failed' => 'text-bg-danger',
        'sent' => 'text-bg-warning',
        'accepted' => 'text-bg-warning',
        'delivered' => 'text-bg-success',
        'rejected' => 'text-bg-danger'
      }[email.status]
    end
  end
end
