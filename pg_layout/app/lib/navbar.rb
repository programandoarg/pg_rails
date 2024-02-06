class Navbar
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def sidebar
    yaml_data = YAML.load_file("#{Rails.application.root}/config/pg_rails.yml")
    sidebar = ActiveSupport::HashWithIndifferentAccess.new(yaml_data)['sidebar']
    # rubocop:disable Security/Eval
    sidebar.map do |item|
      {
        title: item['name'],
        path: eval(item['path']),
        show: true
      }
    end
    # rubocop:enable Security/Eval
  end

  def all_children_hidden?(entry)
    entry[:children].all? { |child| child[:show] == false }
  end

  def any_children_active?(entry, request)
    entry[:children].any? { |child| active_entry?(child, request) }
    true
    # TODO: quitar
  end

  def hide_entry?(entry)
    if entry[:children].present?
      all_children_hidden?(entry)
    else
      entry[:show] == false
    end
  end

  def custom_current_page?(path, request)
    current_route = Rails.application.routes.recognize_path(request.env['PATH_INFO'])
    test_route = Rails.application.routes.recognize_path(path)
    current_route[:controller] == test_route[:controller] && current_route[:action] == test_route[:action]
  rescue ActionController::RoutingError
    false
  end

  def active_entry?(entry, request)
    if entry[:children].present?
      any_children_active?(entry, request)
    elsif entry[:path].present?
      custom_current_page?(entry[:path], request)
    end
  end

  private

  def policy(clase)
    Pundit.policy(@user, clase)
  end
end
