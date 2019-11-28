defmodule TodoDatabaseTest do
  use ExUnit.Case

  test "can start multiple database workers" do
    thing_1 = "thing 1"
    thing_2 = "thing 2"

    {:ok, worker_1} = Todo.DatabaseWorker.start("./persist-test")
    {:ok, worker_2} = Todo.DatabaseWorker.start("./persist-test")

    Todo.DatabaseWorker.store(worker_1, thing_1, thing_1)
    Todo.DatabaseWorker.store(worker_2, thing_2, thing_2)

    assert "thing 1" == Todo.DatabaseWorker.get(worker_1, thing_1)
    assert "thing 2" == Todo.DatabaseWorker.get(worker_2, thing_2)
  end

  test "choose worker returns same value for given key" do
    state = %{0 => "zero", 1 => "one", 2 => "two"}

    assert "one" == Todo.Database.choose_worker(state, "idk some key")
    assert "one" == Todo.Database.choose_worker(state, "idk some key")
    assert "one" == Todo.Database.choose_worker(state, "idk some key")
    assert "one" == Todo.Database.choose_worker(state, "idk some key")
    assert "one" == Todo.Database.choose_worker(state, "idk some key")
  end
end
