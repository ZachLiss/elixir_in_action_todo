defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        # Todo.Metrics,
        # ProcessRegistry is no longer needed after switching to a distributed model
        # Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache,
        Todo.Web
      ],
      strategy: :one_for_one
    )
  end
end
