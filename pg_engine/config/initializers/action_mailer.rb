class MailDeliveryTemporalError < PgEngine::Error; end

ActionMailer::MailDeliveryJob.rescue_from EOFError,
                                      IOError,
                                      # TimeoutError,
                                      Errno::ENETUNREACH,
                                      Errno::EHOSTUNREACH,
                                      Errno::ECONNRESET,
                                      Errno::ECONNABORTED,
                                      Errno::ECONNREFUSED,
                                      Errno::EPIPE,
                                      Errno::ETIMEDOUT,
                                      Net::SMTPAuthenticationError,
                                      Net::SMTPServerBusy,
                                      Net::SMTPSyntaxError,
                                      Net::SMTPUnknownError,
                                      Net::OpenTimeout,
                                      Net::ReadTimeout,
                                      OpenSSL::SSL::SSLError do |e|
  raise MailDeliveryTemporalError, e
end
