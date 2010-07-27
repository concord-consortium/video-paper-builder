# Setup base admin user.
namespace :devise do
  
  desc 'setup devise example migrating db and creating a default user'
  task :setup => ['db:reset','db:drop', 'db:create', 'db:migrate', 'environment'] do
    admin = Admin.create! do |u|
      u.email = 'videopaperbuilder@gmail.com'
      u.password = 'funstuff'
      u.password_confirmation = 'funstuff'
    end
    admin.confirm!
    puts 'New admin created!'
    puts 'Email : ' << admin.email
    puts 'Password: ' << admin.password
  end
end
