# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UsersController < AdminController
    before_action { @clase_modelo = User }

    before_action(only: :index) { authorize User }

    before_action only: %i[update] do
      params[:user].delete(:password) if params[:user][:password].blank?
    end

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb User.nombre_plural, :admin_users_path

    def index
      @users = filtros_y_policy %i[email profiles]
      @users = sort_collection(@users, default: { created_at: :desc })
      pg_respond_index(@users)
    end

    def abrir_modal
      pg_respond_abrir_modal
    end

    def buscar
      pg_respond_buscar
    end

    def show
      add_breadcrumb @user, @user.target_object

      pg_respond_show
    end

    def new
      add_breadcrumb "Crear #{User.nombre_singular.downcase}"
    end

    def edit
      add_breadcrumb @user, @user.target_object
      add_breadcrumb 'Editando'
    end

    def create
      @user.skip_confirmation!
      pg_respond_create
    end

    def update
      @user.skip_reconfirmation!
      pg_respond_update
    end

    def destroy
      pg_respond_destroy(@user, admin_users_url)
    end

    private

    def render_listing
      @users = @users.page(params[:page]).per(current_page_size)
    end

    def atributos_permitidos
      # %i[email password profiles]
      [:email, :password, { profiles: [] }]
    end
  end
end
