defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    # Process.flag(trap_exit: true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, process_key}, caller, state) do
    case Map.has_key?(state, process_key) do
      true ->
        {:reply, :error, state}

      false ->
        Process.link(caller)
        {:reply, :ok, Map.put(state, process_key, caller)}
    end
  end

  @impl GenServer
  def handle_call({:whereis, process_key}, _, state) do
    case Map.get(state, process_key) do
      {pid, _} ->
        {:reply, pid, state}

      nil ->
        {:reply, nil, state}
    end
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    IO.puts("pid EXIT: #{pid}")

    {registered_key, _} =
      state
      |> Enum.find(fn {_, value} -> value == pid end)

    # there could be multiple keys for any pid... we need all of them
    {:noreply, Map.delete(state, registered_key)}
  end

  def register(process_key) do
    GenServer.call(__MODULE__, {:register, process_key})
  end

  def whereis(process_key) do
    GenServer.call(__MODULE__, {:whereis, process_key})
  end
end
