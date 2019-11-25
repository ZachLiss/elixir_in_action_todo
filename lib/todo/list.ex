defmodule Todo.List do
  defstruct auto_id: 1, entries: %{}

  def new() do
    %Todo.List{}
  end

  def new(entries) do
    # Enum.reduce(entries, %Todo.List{}, fn entry, todo_list_acc ->
    #   add_entry(todo_list_acc, entry)
    # end)
    Enum.reduce(entries, %Todo.List{}, &add_entry(&2, &1))
  end

  def add_entry(%Todo.List{auto_id: auto_id, entries: entries} = todo_list, entry) do
    # set id for entry being added
    entry = Map.put(entry, :id, auto_id)

    # add new entry to collection
    new_entries = Map.put(entries, auto_id, entry)

    # update entries field and increment auto_id
    %Todo.List{todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(%Todo.List{entries: entries} = todo_list, entry_id, updater_lambda) do
    case Map.fetch(entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_lambda.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%Todo.List{entries: entries} = todo_list, entry_id) do
    new_entries = Map.delete(entries, entry_id)
    %Todo.List{todo_list | entries: new_entries}
  end
end
