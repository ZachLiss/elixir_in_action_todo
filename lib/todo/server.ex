defmodule Todo.Server do
  use Agent, restart: :temporary

  def start_link(todo_list_name) do
    Agent.start_link(
      fn ->
        IO.puts("Starting to-do server for #{todo_list_name}")
        {todo_list_name, Todo.Database.get(todo_list_name) || Todo.List.new()}
      end,
      name: via_tuple(todo_list_name)
    )
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  # TODO add support for update_entry and delete_entry

  # interface functions
  def add_entry(todo_server, new_entry) do
    Agent.cast(todo_server, fn {todo_list_name, todo_list} ->
      new_list = Todo.List.add_entry(todo_list, new_entry)
      Todo.Database.store(todo_list_name, new_list)
      {todo_list_name, new_list}
    end)
  end

  def entries(todo_server, date) do
    Agent.get(todo_server, fn {_name, todo_list} ->
      Todo.List.entries(todo_list, date)
    end)
  end
end
