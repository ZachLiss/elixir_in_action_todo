defmodule Todo.Server do
  use GenServer

  def start(todo_list_name) do
    GenServer.start(Todo.Server, todo_list_name)
  end

  @impl GenServer
  def init(todo_list_name) do
    {:ok, {todo_list_name, Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {_, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {todo_list_name, todo_list}) do
    {:noreply, {todo_list_name, Todo.List.add_entry(todo_list, new_entry)}}
  end

  # TODO add support for update_entry and delete_entry

  # interface functions
  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end
end
