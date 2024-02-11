DatabaseCleaner.clean_with(:truncation, except: %w(ar_internal_metadata users accounts user_accounts))

MAIL = 'mrosso10@gmail.com'

unless User.where(email: MAIL).exists?
  FactoryBot.create :user, email: MAIL, password: 'admin123',
                           confirmed_at: Time.now, developer: true
end
