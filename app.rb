#encoding: utf-8
#REQUIRE:

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


#Get запросы:

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
	erb :about
end

get '/contact' do
	erb :contact
end
get '/visit' do
	erb :visit
end

get '/admin' do
	erb :admin
end

#POST запросы:

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@master = params[:master]
	@color = params[:color]

	hh = { 	:username  => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату', }

	f = File.open "./public/users.txt", 'a'
	f.write "Name: #{@username}. Phone: #{@phone}. Date and Time: #{@datetime}. Master: #{@master}. Color: #{@color}"
	f.close

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@master}, #{@color}"

end

post '/contact' do
	
	@email = params[:email]
	@message = params[:message]

	hh = { 	:email  => 'Введите email',
			:message => 'Введите отзыв'}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :contact
	end

	f = File.open "./public/message.txt", 'a'
	f.write "Email: #{@email}. Message: #{@message}."
	f.close

	erb "Спасибо за отзыв."

end

post '/admin' do
	
	@login = params[:login]
	@password = params[:password]

	hh = {
		:login => 'Введите логин.',
		:password => 'Введите пароль'
	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :admin
	end

	if @login == 'admin' && @password == 'admin1123'

	#код вывода записавшихся клиентов

	else
		@error = "Логин или пароль не верный"
		erb :admin
	end

end
