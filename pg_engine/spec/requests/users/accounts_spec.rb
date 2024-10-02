require 'rails_helper'

describe 'Users::AccountsController' do
  let(:account) { ActsAsTenant.current_tenant }
  let(:user) { create :user }

  before do
    sign_in user
  end

  it 'shows the owned account' do
    get "/u/cuentas/#{account.to_param}"
    expect(response).to have_http_status(:ok)
  end

  it 'denies foreign account' do
    other_account = create :account
    get "/u/cuentas/#{other_account.to_param}"
    expect(response).to have_http_status(:unauthorized)
  end
end
