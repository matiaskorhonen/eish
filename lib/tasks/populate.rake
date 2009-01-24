namespace :db do
  desc "Erase and fill database with dummy data"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    names = %w[Abigail Andrew Anthony Ava Christopher Daniel Elizabeth Emily Emma Ethan Hannah Isabella Jacob Joshua Madison Matthew Michael Olivia Sophia William]
    admin_users = []
    
    [News, Article, Event, User].each(&:delete_all)
    
    20.times do |i|
      user = User.new
      user.first_name = names[i]
      user.last_name = Faker::Name.last_name
      user.username = names[i].downcase
      user.email = names[i].downcase + "@hhlinuxclub.org"
      user.password = names[i].downcase
      user.role_id = i % 5 + 1
      user.save
      
      admin_users << user.username if user.role.can_administer
    end
    
    News.populate 20 do |news_article|
      news_article.title = Populator.words(3..7).titleize
      news_article.body = Populator.paragraphs(1..3)
      news_article.user_id = User.all[Populator.value_in_range(0..19)].id
      news_article.published = true
      news_article.created_at = Populator.value_in_range(1.year.ago..Time.now)
    end
    
    Article.populate 40 do |article|
      article.title = Populator.words(2..5).titleize
      article.description = Populator.words(10..20).capitalize + "."
      article.body = Populator.paragraphs(5..20)
      article.user_id = User.all[Populator.value_in_range(0..19)].id
      article.published = true
      article.created_at = Populator.value_in_range(1.year.ago..Time.now)
    end
    
    Event.populate 30 do |event|
      event.name = Populator.words(1..3).titleize
      event.starts_at = Populator.value_in_range(1.year.ago..1.year.from_now)      
      event.ends_at = Populator.value_in_range(event.starts_at..event.starts_at + 5.days)
      event.location = Faker::Address.street_address + ", " + Faker::Address.city
      event.is_address = true
      event.published = true
      event.description = Populator.sentences(1..5)
      event.user_id = User.all[Populator.value_in_range(0..19)].id
    end
    
    puts "Users " + admin_users.join(", ") + " are administrators. The passwords are the same as the usernames."  
  end
end