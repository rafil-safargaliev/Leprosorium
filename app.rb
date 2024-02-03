#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do 
    init_db
end

configure do 
	init_db
	@db.execute  'create table if not exists Posts 
	(
		id integer primary key autoincrement,
		created_date date,
		content text
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

# обработчик get-запроса /new
# (браузер получает страницу с сервера)
get '/new' do
	erb :new
  end

# обработчик post-запроса /new
# (браузер отправляет данные на сервер)
post '/new' do
	# получаем переменную из post-запроса
	content = params[:content]

	if content.size <= 0
		@error = 'Type post text'
		return erb :new 
	end 

	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]


	erb "You taiped: #{content}"
end