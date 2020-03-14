# require 'activesupport/time'
class ActiveSupport::TimeWithZone
  def to_s
    strftime('%d/%m/%Y %H:%M')
  end
end
