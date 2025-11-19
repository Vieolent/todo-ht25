require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

get('/') do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @todos = db.execute("SELECT * FROM todos")

    slim(:index)
end

post("/:id/delete") do
    db = SQLite3::Database.new("db/todos.db")
    removing = params[:id].to_i
    db.execute("DELETE FROM todos WHERE id = ?", removing)
    redirect('/')
end

get('/new') do 
    slim(:new)
end

post('/new') do
    new_todo = params[:new_todo]
    description = params[:description]
    db = SQLite3::Database.new("db/todos.db")  
    db.execute("INSERT INTO todos (name, description) VALUES (?, ?) ", [new_todo, description])
    redirect('/')
end

get("/:id/edit") do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @selected_todo = db.execute("SELECT * FROM todos WHERE id=?", id).first
    slim(:"/edit")
end

post("/:id/update") do
    db = SQLite3::Database.new("db/todos.db")  
    id = params[:id].to_i
    name = params[:name]
    description = params[:description]
    db.execute("UPDATE todos SET name=?, description=? WHERE id=?", [name, description, id])
    redirect('/')
end

post("/:id/done") do
    db = SQLite3::Database.new("db/todos.db")  
    id = params[:id].to_i
    db.execute("UPDATE todos SET done=1 WHERE id=?", [id])
    redirect('/')
end
