#encoding: utf-8

#REQUIRE:
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

#Методы:
def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

def is_barber_exists? db, name
	db.execute('SELECT * FROM Barbers WHERE name=?', [name]).length > 0
end

def seed_db db, barbers

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'INSERT INTO Barbers (name) VALUES (?)', [barber]
		end
	end

end

#Инициализация 
configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"name" TEXT, 
			"phone" TEXT, 
			"datestamp" TEXT, 
			"master" TEXT, 
			"color" TEXT
		)'
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Barbers" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"name" TEXT
		)'

		seed_db db, ['Walter', 'Jessie', 'Gus', 'Lidia', 'Mike']

end

#Before
before do
	db = get_db
	@barbers = db.execute 'SELECT * FROM Barbers'
end

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
	db = get_db
	@barbers = db.execute 'SELECT * FROM Barbers'

	erb :visit
end

get '/admin' do
	erb :admin
end

get '/showusers' do
	db = get_db

	@results = db.execute 'SELECT * FROM Users ORDER BY ID DESC'

	erb :showusers
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

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into 
		Users 
		(
			name, 
			phone, 
			datestamp, 
			master, 
			color
		)
		values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @master, @color]

	erb "<h2>Спасибо #{@username}, Вы записались</h2>"

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

	else
		@error = "Логин или пароль не верный"
		erb :admin
	end

end

