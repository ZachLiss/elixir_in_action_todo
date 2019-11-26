defmodule Todo.Server do
  use GenServer

  def start do
    GenServer.start(Todo.Server, nil)
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
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
