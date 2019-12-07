defmodule Todo.Server do
  use GenServer, restart: :temporary

  def start_link(todo_list_name) do
    GenServer.start_link(Todo.Server, todo_list_name, name: via_tuple(todo_list_name))
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  @impl GenServer
  def init(todo_list_name) do
    IO.puts("Starting to-do server for #{todo_list_name}")
    {:ok, {todo_list_name, Todo.Database.get(todo_list_name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {_, todo_list} = state) do
    {:reply, Todo.List.entries(todo_list, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {todo_list_name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(todo_list_name, new_list)
    {:noreply, {todo_list_name, new_list}}
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
