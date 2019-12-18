defmodule Todo.Application do
  def start(_, _) do
    Todo.System.start_link()
  end
end
