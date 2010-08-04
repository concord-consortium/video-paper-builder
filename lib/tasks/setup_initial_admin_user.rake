# Setup base admin user.
namespace :devise do
  
  desc 'setup devise example migrating db and creating a default user'
  task :setup => ['db:reset','db:drop', 'db:create', 'db:migrate', 'environment'] do
    admin = Admin.create! do |u|
      u.first_name = 'Bob'
      u.last_name = 'Bobberino'
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
      u.first_name = 'Robert'
      u.last_name = 'Bobberson'
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
    
    user_2 = User.create! do |u|
      u.first_name = 'Sly'
      u.last_name = 'Stone'
      u.email = "sharing_user@velir.com"
      u.password = 'funstuff'
      u.password_confirmation = 'funstuff'
    end
    user_2.confirm!   
    puts 'New user created!'
    puts 'Email: ' << user_2.email
    puts 'Password: ' << user_2.password     
  end 
end
