class InlineShowComponent < ViewComponent::Base
  def initialize(model, attribute)
    @model = model
    @attribute = attribute
    @frame_id = dom_id(model, "#{attribute}_inline_edit")

    super
  end

  def before_render
    return unless controller.in_modal?

    controller.instance_variable_set(:@using_modal, true)
  end
end
