namespace :db do
	desc "将示例用户填写到数据库里面" 
		task populate: :environment do #将示例用户加入到环境开发中，替换先前注册的用户
		admin = User.create!(name: "Example User",
									 email: "example@railstutorial.org",
									 password: 123456,
									 password_confirmation: 123456)
	
			admin.toggle!(:admin)
		#创建100个用户
			99.times do |n|
				name = Faker::Name.name
				email = "example-#{n+1}@railstutorial.org"
				password = "password"
				User.create!(name: name,
										 email: email,
										 password: password,
										 password_confirmation: password)
			end

			users = User.all(limit: 6)
			50.times do
				content = Faker::Lorem.sentence(5)
				users.each { |user| user.microposts.create!(content: content)}
			end
		end
	end
