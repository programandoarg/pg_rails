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

    def create
      @user.skip_confirmation!
      pg_respond_create
    end

    def update
      @user.skip_reconfirmation!
      pg_respond_update
    end

    skip_before_action :authenticate_user!, only: [:login_as]

    def login_as
      if current_user&.developer? || Rails.env.development?
        usuario = User.find(params[:id])
        sign_in(:user, usuario)
      end
      redirect_to '/'
    end

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
