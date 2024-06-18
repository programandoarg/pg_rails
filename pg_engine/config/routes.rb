include PgEngine::RouteHelpers

Rails.application.routes.draw do
  get "pg_engine/health" => "pg_engine/health#show", as: :pg_engine_health_check

  get '404', to: 'pg_engine/base#page_not_found'
  get '500', to: 'pg_engine/base#internal_error'

  namespace :public, path: '' do
    pg_resource(:mensaje_contactos, only: [:new, :create], path: 'contacto')
    post 'webhook/mailgun', to: 'webhooks#mailgun'
  end
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }, failure_app: PgEngine::DeviseFailureApp
  namespace :users, path: 'u' do
    post 'notifications/mark_as_seen', to: 'notifications#mark_as_seen'
  end
  namespace :admin, path: 'a' do
    pg_resource(:emails)
    pg_resource(:email_logs) do
      collection do
        post :mailgun_sync
      end
    end
    pg_resource(:users)
    pg_resource(:accounts)
    pg_resource(:user_accounts)
    get 'login_as', to: 'users#login_as'
  end
  ActiveAdmin.routes(self)
end

#                                       Prefix Verb   URI Pattern                                                                                       Controller#Action
#                   abrir_modal_frontend_cosas GET    /frontend/cosas/abrir_modal(.:format)                                                             frontend/cosas#abrir_modal
#                        buscar_frontend_cosas POST   /frontend/cosas/buscar(.:format)                                                                  frontend/cosas#buscar
#                               frontend_cosas GET    /frontend/cosas(.:format)                                                                         frontend/cosas#index
#                                              POST   /frontend/cosas(.:format)                                                                         frontend/cosas#create
#                            new_frontend_cosa GET    /frontend/cosas/new(.:format)                                                                     frontend/cosas#new
#                           edit_frontend_cosa GET    /frontend/cosas/:id/edit(.:format)                                                                frontend/cosas#edit
#                                frontend_cosa GET    /frontend/cosas/:id(.:format)                                                                     frontend/cosas#show
#                                              PATCH  /frontend/cosas/:id(.:format)                                                                     frontend/cosas#update
#                                              PUT    /frontend/cosas/:id(.:format)                                                                     frontend/cosas#update
#                                              DELETE /frontend/cosas/:id(.:format)                                                                     frontend/cosas#destroy
#      abrir_modal_frontend_categoria_de_cosas GET    /frontend/categoria_de_cosas/abrir_modal(.:format)                                                frontend/categoria_de_cosas#abrir_modal
#           buscar_frontend_categoria_de_cosas POST   /frontend/categoria_de_cosas/buscar(.:format)                                                     frontend/categoria_de_cosas#buscar
#                  frontend_categoria_de_cosas GET    /frontend/categoria_de_cosas(.:format)                                                            frontend/categoria_de_cosas#index
#                                              POST   /frontend/categoria_de_cosas(.:format)                                                            frontend/categoria_de_cosas#create
#               new_frontend_categoria_de_cosa GET    /frontend/categoria_de_cosas/new(.:format)                                                        frontend/categoria_de_cosas#new
#              edit_frontend_categoria_de_cosa GET    /frontend/categoria_de_cosas/:id/edit(.:format)                                                   frontend/categoria_de_cosas#edit
#                   frontend_categoria_de_cosa GET    /frontend/categoria_de_cosas/:id(.:format)                                                        frontend/categoria_de_cosas#show
#                                              PATCH  /frontend/categoria_de_cosas/:id(.:format)                                                        frontend/categoria_de_cosas#update
#                                              PUT    /frontend/categoria_de_cosas/:id(.:format)                                                        frontend/categoria_de_cosas#update
#                                              DELETE /frontend/categoria_de_cosas/:id(.:format)                                                        frontend/categoria_de_cosas#destroy
#                      abrir_modal_admin_cosas GET    /admin/cosas/abrir_modal(.:format)                                                                admin/cosas#abrir_modal
#                           buscar_admin_cosas POST   /admin/cosas/buscar(.:format)                                                                     admin/cosas#buscar
#                                  admin_cosas GET    /admin/cosas(.:format)                                                                            admin/cosas#index
#                                              POST   /admin/cosas(.:format)                                                                            admin/cosas#create
#                               new_admin_cosa GET    /admin/cosas/new(.:format)                                                                        admin/cosas#new
#                              edit_admin_cosa GET    /admin/cosas/:id/edit(.:format)                                                                   admin/cosas#edit
#                                   admin_cosa GET    /admin/cosas/:id(.:format)                                                                        admin/cosas#show
#                                              PATCH  /admin/cosas/:id(.:format)                                                                        admin/cosas#update
#                                              PUT    /admin/cosas/:id(.:format)                                                                        admin/cosas#update
#                                              DELETE /admin/cosas/:id(.:format)                                                                        admin/cosas#destroy
#         abrir_modal_admin_categoria_de_cosas GET    /admin/categoria_de_cosas/abrir_modal(.:format)                                                   admin/categoria_de_cosas#abrir_modal
#              buscar_admin_categoria_de_cosas POST   /admin/categoria_de_cosas/buscar(.:format)                                                        admin/categoria_de_cosas#buscar
#                     admin_categoria_de_cosas GET    /admin/categoria_de_cosas(.:format)                                                               admin/categoria_de_cosas#index
#                                              POST   /admin/categoria_de_cosas(.:format)                                                               admin/categoria_de_cosas#create
#                  new_admin_categoria_de_cosa GET    /admin/categoria_de_cosas/new(.:format)                                                           admin/categoria_de_cosas#new
#                 edit_admin_categoria_de_cosa GET    /admin/categoria_de_cosas/:id/edit(.:format)                                                      admin/categoria_de_cosas#edit
#                      admin_categoria_de_cosa GET    /admin/categoria_de_cosas/:id(.:format)                                                           admin/categoria_de_cosas#show
#                                              PATCH  /admin/categoria_de_cosas/:id(.:format)                                                           admin/categoria_de_cosas#update
#                                              PUT    /admin/categoria_de_cosas/:id(.:format)                                                           admin/categoria_de_cosas#update
#                                              DELETE /admin/categoria_de_cosas/:id(.:format)                                                           admin/categoria_de_cosas#destroy
#                                         root GET    /                                                                                                 admin/categoria_de_cosas#index
#                         action_with_redirect GET    /action_with_redirect(.:format)                                                                   dummy_base#action_with_redirect
#                               check_dev_user GET    /check_dev_user(.:format)                                                                         dummy_base#check_dev_user
#                          test_not_authorized GET    /test_not_authorized(.:format)                                                                    dummy_base#test_not_authorized
#                          test_internal_error GET    /test_internal_error(.:format)                                                                    dummy_base#test_internal_error
#             turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#             turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#            turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#         abrir_modal_public_mensaje_contactos GET    /contacto/abrir_modal(.:format)                                                                   public/mensaje_contactos#abrir_modal
#              buscar_public_mensaje_contactos POST   /contacto/buscar(.:format)                                                                        public/mensaje_contactos#buscar
#                     public_mensaje_contactos POST   /contacto(.:format)                                                                               public/mensaje_contactos#create
#                  new_public_mensaje_contacto GET    /contacto/new(.:format)                                                                           public/mensaje_contactos#new
#                             new_user_session GET    /users/sign_in(.:format)                                                                          devise/sessions#new
#                                 user_session POST   /users/sign_in(.:format)                                                                          devise/sessions#create
#                         destroy_user_session DELETE /users/sign_out(.:format)                                                                         devise/sessions#destroy
#                            new_user_password GET    /users/password/new(.:format)                                                                     devise/passwords#new
#                           edit_user_password GET    /users/password/edit(.:format)                                                                    devise/passwords#edit
#                                user_password PATCH  /users/password(.:format)                                                                         devise/passwords#update
#                                              PUT    /users/password(.:format)                                                                         devise/passwords#update
#                                              POST   /users/password(.:format)                                                                         devise/passwords#create
#                     cancel_user_registration GET    /users/cancel(.:format)                                                                           users/registrations#cancel
#                        new_user_registration GET    /users/sign_up(.:format)                                                                          users/registrations#new
#                       edit_user_registration GET    /users/edit(.:format)                                                                             users/registrations#edit
#                            user_registration PATCH  /users(.:format)                                                                                  users/registrations#update
#                                              PUT    /users(.:format)                                                                                  users/registrations#update
#                                              DELETE /users(.:format)                                                                                  users/registrations#destroy
#                                              POST   /users(.:format)                                                                                  users/registrations#create
#                        new_user_confirmation GET    /users/confirmation/new(.:format)                                                                 users/confirmations#new
#                            user_confirmation GET    /users/confirmation(.:format)                                                                     users/confirmations#show
#                                              POST   /users/confirmation(.:format)                                                                     users/confirmations#create
#                              new_user_unlock GET    /users/unlock/new(.:format)                                                                       devise/unlocks#new
#                                  user_unlock GET    /users/unlock(.:format)                                                                           devise/unlocks#show
#                                              POST   /users/unlock(.:format)                                                                           devise/unlocks#create
#                     abrir_modal_admin_emails GET    /a/emails/abrir_modal(.:format)                                                                   admin/emails#abrir_modal
#                          buscar_admin_emails POST   /a/emails/buscar(.:format)                                                                        admin/emails#buscar
#                                 admin_emails GET    /a/emails(.:format)                                                                               admin/emails#index
#                                              POST   /a/emails(.:format)                                                                               admin/emails#create
#                              new_admin_email GET    /a/emails/new(.:format)                                                                           admin/emails#new
#                             edit_admin_email GET    /a/emails/:id/edit(.:format)                                                                      admin/emails#edit
#                                  admin_email GET    /a/emails/:id(.:format)                                                                           admin/emails#show
#                                              PATCH  /a/emails/:id(.:format)                                                                           admin/emails#update
#                                              PUT    /a/emails/:id(.:format)                                                                           admin/emails#update
#                                              DELETE /a/emails/:id(.:format)                                                                           admin/emails#destroy
#                 abrir_modal_admin_email_logs GET    /a/email_logs/abrir_modal(.:format)                                                               admin/email_logs#abrir_modal
#                      buscar_admin_email_logs POST   /a/email_logs/buscar(.:format)                                                                    admin/email_logs#buscar
#                mailgun_sync_admin_email_logs POST   /a/email_logs/mailgun_sync(.:format)                                                              admin/email_logs#mailgun_sync
#                             admin_email_logs GET    /a/email_logs(.:format)                                                                           admin/email_logs#index
#                                              POST   /a/email_logs(.:format)                                                                           admin/email_logs#create
#                          new_admin_email_log GET    /a/email_logs/new(.:format)                                                                       admin/email_logs#new
#                         edit_admin_email_log GET    /a/email_logs/:id/edit(.:format)                                                                  admin/email_logs#edit
#                              admin_email_log GET    /a/email_logs/:id(.:format)                                                                       admin/email_logs#show
#                                              PATCH  /a/email_logs/:id(.:format)                                                                       admin/email_logs#update
#                                              PUT    /a/email_logs/:id(.:format)                                                                       admin/email_logs#update
#                                              DELETE /a/email_logs/:id(.:format)                                                                       admin/email_logs#destroy
#                      abrir_modal_admin_users GET    /a/users/abrir_modal(.:format)                                                                    admin/users#abrir_modal
#                           buscar_admin_users POST   /a/users/buscar(.:format)                                                                         admin/users#buscar
#                                  admin_users GET    /a/users(.:format)                                                                                admin/users#index
#                                              POST   /a/users(.:format)                                                                                admin/users#create
#                               new_admin_user GET    /a/users/new(.:format)                                                                            admin/users#new
#                              edit_admin_user GET    /a/users/:id/edit(.:format)                                                                       admin/users#edit
#                                   admin_user GET    /a/users/:id(.:format)                                                                            admin/users#show
#                                              PATCH  /a/users/:id(.:format)                                                                            admin/users#update
#                                              PUT    /a/users/:id(.:format)                                                                            admin/users#update
#                                              DELETE /a/users/:id(.:format)                                                                            admin/users#destroy
#                   abrir_modal_admin_accounts GET    /a/accounts/abrir_modal(.:format)                                                                 admin/accounts#abrir_modal
#                        buscar_admin_accounts POST   /a/accounts/buscar(.:format)                                                                      admin/accounts#buscar
#                               admin_accounts GET    /a/accounts(.:format)                                                                             admin/accounts#index
#                                              POST   /a/accounts(.:format)                                                                             admin/accounts#create
#                            new_admin_account GET    /a/accounts/new(.:format)                                                                         admin/accounts#new
#                           edit_admin_account GET    /a/accounts/:id/edit(.:format)                                                                    admin/accounts#edit
#                                admin_account GET    /a/accounts/:id(.:format)                                                                         admin/accounts#show
#                                              PATCH  /a/accounts/:id(.:format)                                                                         admin/accounts#update
#                                              PUT    /a/accounts/:id(.:format)                                                                         admin/accounts#update
#                                              DELETE /a/accounts/:id(.:format)                                                                         admin/accounts#destroy
#              abrir_modal_admin_user_accounts GET    /a/user_accounts/abrir_modal(.:format)                                                            admin/user_accounts#abrir_modal
#                   buscar_admin_user_accounts POST   /a/user_accounts/buscar(.:format)                                                                 admin/user_accounts#buscar
#                          admin_user_accounts GET    /a/user_accounts(.:format)                                                                        admin/user_accounts#index
#                                              POST   /a/user_accounts(.:format)                                                                        admin/user_accounts#create
#                       new_admin_user_account GET    /a/user_accounts/new(.:format)                                                                    admin/user_accounts#new
#                      edit_admin_user_account GET    /a/user_accounts/:id/edit(.:format)                                                               admin/user_accounts#edit
#                           admin_user_account GET    /a/user_accounts/:id(.:format)                                                                    admin/user_accounts#show
#                                              PATCH  /a/user_accounts/:id(.:format)                                                                    admin/user_accounts#update
#                                              PUT    /a/user_accounts/:id(.:format)                                                                    admin/user_accounts#update
#                                              DELETE /a/user_accounts/:id(.:format)                                                                    admin/user_accounts#destroy
#                               admin_login_as GET    /a/login_as(.:format)                                                                             admin/users#login_as
#                            active_admin_root GET    /active_admin(.:format)                                                                           active_admin/dashboard#index
# batch_action_active_admin_categoria_de_cosas POST   /active_admin/categoria_de_cosas/batch_action(.:format)                                           active_admin/categoria_de_cosas#batch_action
#              active_admin_categoria_de_cosas GET    /active_admin/categoria_de_cosas(.:format)                                                        active_admin/categoria_de_cosas#index
#                                              POST   /active_admin/categoria_de_cosas(.:format)                                                        active_admin/categoria_de_cosas#create
#           new_active_admin_categoria_de_cosa GET    /active_admin/categoria_de_cosas/new(.:format)                                                    active_admin/categoria_de_cosas#new
#          edit_active_admin_categoria_de_cosa GET    /active_admin/categoria_de_cosas/:id/edit(.:format)                                               active_admin/categoria_de_cosas#edit
#               active_admin_categoria_de_cosa GET    /active_admin/categoria_de_cosas/:id(.:format)                                                    active_admin/categoria_de_cosas#show
#                                              PATCH  /active_admin/categoria_de_cosas/:id(.:format)                                                    active_admin/categoria_de_cosas#update
#                                              PUT    /active_admin/categoria_de_cosas/:id(.:format)                                                    active_admin/categoria_de_cosas#update
#                                              DELETE /active_admin/categoria_de_cosas/:id(.:format)                                                    active_admin/categoria_de_cosas#destroy
#              batch_action_active_admin_cosas POST   /active_admin/cosas/batch_action(.:format)                                                        active_admin/cosas#batch_action
#                           active_admin_cosas GET    /active_admin/cosas(.:format)                                                                     active_admin/cosas#index
#                                              POST   /active_admin/cosas(.:format)                                                                     active_admin/cosas#create
#                        new_active_admin_cosa GET    /active_admin/cosas/new(.:format)                                                                 active_admin/cosas#new
#                       edit_active_admin_cosa GET    /active_admin/cosas/:id/edit(.:format)                                                            active_admin/cosas#edit
#                            active_admin_cosa GET    /active_admin/cosas/:id(.:format)                                                                 active_admin/cosas#show
#                                              PATCH  /active_admin/cosas/:id(.:format)                                                                 active_admin/cosas#update
#                                              PUT    /active_admin/cosas/:id(.:format)                                                                 active_admin/cosas#update
#                                              DELETE /active_admin/cosas/:id(.:format)                                                                 active_admin/cosas#destroy
#           batch_action_active_admin_accounts POST   /active_admin/accounts/batch_action(.:format)                                                     active_admin/accounts#batch_action
#                        active_admin_accounts GET    /active_admin/accounts(.:format)                                                                  active_admin/accounts#index
#                                              POST   /active_admin/accounts(.:format)                                                                  active_admin/accounts#create
#                     new_active_admin_account GET    /active_admin/accounts/new(.:format)                                                              active_admin/accounts#new
#                    edit_active_admin_account GET    /active_admin/accounts/:id/edit(.:format)                                                         active_admin/accounts#edit
#                         active_admin_account GET    /active_admin/accounts/:id(.:format)                                                              active_admin/accounts#show
#                                              PATCH  /active_admin/accounts/:id(.:format)                                                              active_admin/accounts#update
#                                              PUT    /active_admin/accounts/:id(.:format)                                                              active_admin/accounts#update
#                                              DELETE /active_admin/accounts/:id(.:format)                                                              active_admin/accounts#destroy
#     batch_action_active_admin_audited_audits POST   /active_admin/audited_audits/batch_action(.:format)                                               active_admin/audited_audits#batch_action
#                  active_admin_audited_audits GET    /active_admin/audited_audits(.:format)                                                            active_admin/audited_audits#index
#                   active_admin_audited_audit GET    /active_admin/audited_audits/:id(.:format)                                                        active_admin/audited_audits#show
#                       active_admin_dashboard GET    /active_admin/dashboard(.:format)                                                                 active_admin/dashboard#index
#         batch_action_active_admin_email_logs POST   /active_admin/email_logs/batch_action(.:format)                                                   active_admin/email_logs#batch_action
#                      active_admin_email_logs GET    /active_admin/email_logs(.:format)                                                                active_admin/email_logs#index
#                                              POST   /active_admin/email_logs(.:format)                                                                active_admin/email_logs#create
#                   new_active_admin_email_log GET    /active_admin/email_logs/new(.:format)                                                            active_admin/email_logs#new
#                  edit_active_admin_email_log GET    /active_admin/email_logs/:id/edit(.:format)                                                       active_admin/email_logs#edit
#                       active_admin_email_log GET    /active_admin/email_logs/:id(.:format)                                                            active_admin/email_logs#show
#                                              PATCH  /active_admin/email_logs/:id(.:format)                                                            active_admin/email_logs#update
#                                              PUT    /active_admin/email_logs/:id(.:format)                                                            active_admin/email_logs#update
#                                              DELETE /active_admin/email_logs/:id(.:format)                                                            active_admin/email_logs#destroy
#             batch_action_active_admin_emails POST   /active_admin/emails/batch_action(.:format)                                                       active_admin/emails#batch_action
#                          active_admin_emails GET    /active_admin/emails(.:format)                                                                    active_admin/emails#index
#                           active_admin_email GET    /active_admin/emails/:id(.:format)                                                                active_admin/emails#show
#  batch_action_active_admin_mensaje_contactos POST   /active_admin/mensaje_contactos/batch_action(.:format)                                            active_admin/mensaje_contactos#batch_action
#               active_admin_mensaje_contactos GET    /active_admin/mensaje_contactos(.:format)                                                         active_admin/mensaje_contactos#index
#                                              POST   /active_admin/mensaje_contactos(.:format)                                                         active_admin/mensaje_contactos#create
#            new_active_admin_mensaje_contacto GET    /active_admin/mensaje_contactos/new(.:format)                                                     active_admin/mensaje_contactos#new
#           edit_active_admin_mensaje_contacto GET    /active_admin/mensaje_contactos/:id/edit(.:format)                                                active_admin/mensaje_contactos#edit
#                active_admin_mensaje_contacto GET    /active_admin/mensaje_contactos/:id(.:format)                                                     active_admin/mensaje_contactos#show
#                                              PATCH  /active_admin/mensaje_contactos/:id(.:format)                                                     active_admin/mensaje_contactos#update
#                                              PUT    /active_admin/mensaje_contactos/:id(.:format)                                                     active_admin/mensaje_contactos#update
#                                              DELETE /active_admin/mensaje_contactos/:id(.:format)                                                     active_admin/mensaje_contactos#destroy
#      batch_action_active_admin_user_accounts POST   /active_admin/user_accounts/batch_action(.:format)                                                active_admin/user_accounts#batch_action
#                   active_admin_user_accounts GET    /active_admin/user_accounts(.:format)                                                             active_admin/user_accounts#index
#                                              POST   /active_admin/user_accounts(.:format)                                                             active_admin/user_accounts#create
#                new_active_admin_user_account GET    /active_admin/user_accounts/new(.:format)                                                         active_admin/user_accounts#new
#               edit_active_admin_user_account GET    /active_admin/user_accounts/:id/edit(.:format)                                                    active_admin/user_accounts#edit
#                    active_admin_user_account GET    /active_admin/user_accounts/:id(.:format)                                                         active_admin/user_accounts#show
#                                              PATCH  /active_admin/user_accounts/:id(.:format)                                                         active_admin/user_accounts#update
#                                              PUT    /active_admin/user_accounts/:id(.:format)                                                         active_admin/user_accounts#update
#                                              DELETE /active_admin/user_accounts/:id(.:format)                                                         active_admin/user_accounts#destroy
#                    confirm_active_admin_user PUT    /active_admin/users/:id/confirm(.:format)                                                         active_admin/users#confirm
#                    discard_active_admin_user PUT    /active_admin/users/:id/discard(.:format)                                                         active_admin/users#discard
#                    restore_active_admin_user PUT    /active_admin/users/:id/restore(.:format)                                                         active_admin/users#restore
#              batch_action_active_admin_users POST   /active_admin/users/batch_action(.:format)                                                        active_admin/users#batch_action
#                           active_admin_users GET    /active_admin/users(.:format)                                                                     active_admin/users#index
#                                              POST   /active_admin/users(.:format)                                                                     active_admin/users#create
#                        new_active_admin_user GET    /active_admin/users/new(.:format)                                                                 active_admin/users#new
#                       edit_active_admin_user GET    /active_admin/users/:id/edit(.:format)                                                            active_admin/users#edit
#                            active_admin_user GET    /active_admin/users/:id(.:format)                                                                 active_admin/users#show
#                                              PATCH  /active_admin/users/:id(.:format)                                                                 active_admin/users#update
#                                              PUT    /active_admin/users/:id(.:format)                                                                 active_admin/users#update
#                                              DELETE /active_admin/users/:id(.:format)                                                                 active_admin/users#destroy
#                        active_admin_comments GET    /active_admin/comments(.:format)                                                                  active_admin/comments#index
#                                              POST   /active_admin/comments(.:format)                                                                  active_admin/comments#create
#                         active_admin_comment GET    /active_admin/comments/:id(.:format)                                                              active_admin/comments#show
#                                              DELETE /active_admin/comments/:id(.:format)                                                              active_admin/comments#destroy
#                rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#                   rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#                rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#          rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#                rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#                 rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#               rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                              POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#            new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#                rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#     new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#        rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#        rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#     rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                           rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                     rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                              GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                    rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#              rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                              GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                           rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                    update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                         rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
