['mrosso10@gmail.com'].each do |mail|
  unless User.exists?(email: mail)
    User.create(email: mail, password: 'admin123', confirmed_at: Time.now, developer: true)
  end
end
