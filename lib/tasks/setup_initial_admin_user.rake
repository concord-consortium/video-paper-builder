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
  
  desc 'create default admin user'
  task :create_admin => ['environment'] do
    admin = Admin.new do |u|
      u.first_name = 'Bob'
      u.last_name = 'Bobberino'
      u.email = 'videopaperbuilder@gmail.com'
      u.password = 'funstuff'
      u.password_confirmation = 'funstuff'
    end
    admin.skip_confirmation!
    admin.save
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
    paper.publish!
    puts 'New Video Paper created!'
    puts 'Title: ' << paper.title
    puts 'User: ' << paper.user.email
    #find a video with the category of "test" to eff with.
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    entry = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == Rails.env}.compact!.last.id
    video = Video.new(
      :entry_id=> entry,
      :video_paper_id => paper.id,
      :description => "this is an awesome description",
      :private => false,
      :language_id => Language.find_by_code('en').id
    )
    video.save
    
    paper_2 = VideoPaper.new
    paper_2.title = "Less Generic Video Paper"
    paper_2.user = user
    paper_2.save
    paper_2.publish!
    puts 'New Video Paper created!'
    puts 'Title: ' << paper_2.title
    puts 'User: ' << paper_2.user.email
    
    paper_3 = VideoPaper.new
    paper_3.title = "Unpublished Paper"
    paper_3.user = user
    paper_3.save
    puts 'New Video Paper created!'
    puts 'Title: ' << paper_3.title
    puts 'User: ' << paper_3.user.email
    #find a video with the category of "test" to eff with.
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    entry = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == Rails.env}.compact!.last.id
    video_2 = Video.new(
      :entry_id=> entry,
      :video_paper_id => paper_2.id,
      :description => "this is an awesome description",
      :private => true,
      :language_id => Language.find_by_code('en').id
    )
    video_2.save
    
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
    
    user_3 = User.create! do |u|
      u.first_name = 'OK'
      u.last_name = 'Coral'
      u.email = "random_user@velir.com"
      u.password = 'funstuff'
      u.password_confirmation = 'funstuff'
    end
    user_3.confirm!   
    puts 'New user created!'
    puts 'Email: ' << user_3.email
    puts 'Password: ' << user_3.password   
  end 
end
