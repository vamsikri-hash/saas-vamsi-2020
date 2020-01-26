require "date"

class Todo
  attr_accessor :text, :due_date, :completed

  def initialize(text, due_date, completed)
    @text = text
    @due_date = due_date
    @completed = completed
  end

  def overdue?
    Date.today > @due_date && !@completed
  end

  def due_today?
    Date.today == @due_date
  end

  def due_later?
    Date.today < @due_date
  end

  def to_s
    @show_date = due_today? ? "" : @due_date
    @check_box = @completed ? "[X]" : "[ ]"
    "#{@check_box} #{@text}  #{@show_date}"
  end
end

class TodosList
  attr_accessor :todos

  def initialize(todos)
    @todos = todos
  end

  def add(new_todo)
    @todos << new_todo
  end

  def overdue
    TodosList.new(@todos.filter { |todo| todo.overdue? })
  end

  def due_today
    TodosList.new(@todos.filter { |todo| todo.due_today? })
  end

  def due_later
    TodosList.new(@todos.filter { |todo| todo.due_later? })
  end

  def to_s
    @todos
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodosList.new(todos)

todos_list.add(Todo.new("Service vehicle", date, false))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_s
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_s
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_s
puts "\n\n"
