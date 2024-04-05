# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  apellido               :string           not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  developer              :boolean          default(FALSE), not null
#  discarded_at           :datetime
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  nombre                 :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string           indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :lockable, :timeoutable, :trackable, :confirmable

  audited
  include Discard::Model

  has_many :user_accounts
  has_many :accounts, through: :user_accounts

  validates :nombre, :apellido, presence: true

  validates_presence_of   :email
  validates_uniqueness_of :email, message: 'ya pertenece a un usuario'
  validates_format_of     :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?, message: 'Las contraseñas no coinciden'
  validates_length_of       :password, if: :password_required?, within: 6..128,
                                       message: 'es demasiado corta (6 caracteres mínimo)'

  attr_accessor :orphan

  after_create do
    # TODO: si fue invitado, sumar a la account del invitador
    create_account unless orphan
  end

  def create_account
    account = Account.create(nombre: email, plan: 0)
    ua = user_accounts.create(account:)
    raise(ActiveRecord::Rollback) unless ua.persisted?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  scope :query, ->(param) { where('email ILIKE ?', "%#{param}%") }

  def to_s
    nombre_completo
  end

  def nombre_completo
    "#{nombre} #{apellido}"
  end

  class Error < PgEngine::Error; end

  def current_account
    raise Error, 'El usuario debe tener cuenta' if accounts.empty?

    accounts.first
  end
end
