defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    IO.puts("Starting database server.")
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    # start three workers and store pids in a map
    pid_map =
      Enum.reduce(0..2, %{}, fn i, acc ->
        {:ok, worker_pid} = Todo.DatabaseWorker.start(@db_folder)
        Map.put(acc, i, worker_pid)
      end)

    {:ok, pid_map}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, state) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(state, worker_key), state}
  end
end
