['mrosso10@gmail.com'].each do |mail|
  unless User.exists?(email: mail)
    User.create(email: mail, password: 'admin123', profiles: [:admin], confirmed_at: Time.now)
  end
end
