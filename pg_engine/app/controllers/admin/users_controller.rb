# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UsersController < AdminController
    include PgEngine::Resource

    before_action { @clase_modelo = User }

    before_action(only: :index) { authorize User }

    before_action only: %i[update] do
      params[:user].delete(:password) if params[:user][:password].blank?
    end

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb User.nombre_plural, :admin_users_path

    def create
      @user.skip_confirmation!
      pg_respond_create
    end

    def update
      @user.skip_reconfirmation!
      pg_respond_update
    end

    skip_before_action :authenticate_user!, only: [:login_as]

    # :nocov:
    def login_as
      if dev_user_or_env?
        usuario = User.find(params[:id])
        sign_in(:user, usuario)
      end
      redirect_to after_sign_in_path_for(usuario)
    end
    # :nocov:

    private

    def atributos_permitidos
      %i[email nombre apellido password developer]
    end

    def atributos_para_buscar
      %i[email nombre apellido developer]
    end

    def atributos_para_listar
      %i[email nombre apellido developer]
    end

    def atributos_para_mostrar
      %i[email nombre apellido developer]
    end
  end
end
