module Users
  class InlineEditController < PgEngine.config.users_controller
    before_action do
      if current_turbo_frame.blank?
        render_my_component(BadRequestComponent.new, :bad_request)
      end
    end

    def edit
      model = GlobalID::Locator.locate params[:model]
      attribute = params[:attribute]
      render InlineEditComponent.new(model, attribute), layout: false
    end

    def show
      model = GlobalID::Locator.locate params[:model]
      attribute = params[:attribute]
      render InlineShowComponent.new(model, attribute), layout: false
    end
  end
end
