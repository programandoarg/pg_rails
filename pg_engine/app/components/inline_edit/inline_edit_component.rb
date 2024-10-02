class InlineEditComponent < ViewComponent::Base
  def initialize(model, attribute)
    @model = model
    @attribute = attribute
    @frame_id = dom_id(model, "#{attribute}_inline_edit")

    @wrapper_mappings = {
      string: :inline_form_control,
      pg_associable: :inline_form_control,
      date: :inline_form_control,
      datetime: :inline_form_control,
      select: :inline_form_select
    }

    super
  end

  def before_render
    return unless controller.in_modal?

    controller.instance_variable_set(:@using_modal, true)
  end
end
