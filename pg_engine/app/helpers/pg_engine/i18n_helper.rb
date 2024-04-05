module PgEngine
  module I18nHelper
    def controller_key
      controller.class.to_s.underscore.sub(/_controller\z/, '')
    end
  end
end