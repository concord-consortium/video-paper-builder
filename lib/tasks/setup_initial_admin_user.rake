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
  
  desc 'setup test database fixtures'
  task :test => ['devise:setup'] do
    user = User.create! do |u|
      u.email = "test_user@velir.com"
      u.password = 'funstuff'
      u.password_confirmation = 'funstuff'
    end
    user.confirm!
    puts 'New user created!'
    puts 'Email: ' << user.email
    puts 'Password: ' << user.password
    
    paper = VideoPaper.new
    paper.title = "Generic Video Paper"
    paper.user = user
    paper.save
    puts 'New Video Paper created!'
    puts 'Title: ' << paper.title
    puts 'User: ' << paper.user.email
  end 
end
