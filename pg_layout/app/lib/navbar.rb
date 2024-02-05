class Navbar
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  # FIXME: 
  def sidebar
    [
      { title: 'Home', path: root_path, show: true },
      # { title: 'Categorias', path: admin_categoria_de_cosas_path, show: policy(CategoriaDeCosa).index? },
      # { title: 'Personas', path: admin_personas_path, show: policy(CategoriaDeCosa).index? },
      # { title: 'blas', path: admin_blas_path, show: policy(CategoriaDeCosa).index? },
      # { title: 'ActiveAdmin', path: active_admin_root_path, show: policy(CategoriaDeCosa).index? }
      # { title: 'Inicio', children: [
      # { title: 'Turnos', path: turnos_path, show: true },
      # { title: 'Second', path: second_path, show: true },
      # { title: 'Not show', path: 'cosas', show: false },
      # { title: 'Backups y Server', path: '/backups', show: true }
      # ] },
    ]
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
