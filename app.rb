require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

get('/') do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    @todosDone = db.execute("SELECT * FROM todos WHERE done = 1 ORDER BY category ASC")
    @todosNotDone = db.execute("SELECT * FROM todos WHERE done = 0 ORDER BY category ASC")

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
    category = params[:category]
    db = SQLite3::Database.new("db/todos.db")  
    db.execute("INSERT INTO todos (name, description, done, category) VALUES (?, ?, 0, ?) ", [new_todo, description, category])
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
    category = params[:category]
    description = params[:description]
    db.execute("UPDATE todos SET name=?, description=?, category=? WHERE id=?", [name, description, category, id])
    redirect('/')
end

post("/:id/done") do
    db = SQLite3::Database.new("db/todos.db")  
    id = params[:id].to_i
    db.execute("UPDATE todos SET done=1 WHERE id=?", [id])
    redirect('/')
end
