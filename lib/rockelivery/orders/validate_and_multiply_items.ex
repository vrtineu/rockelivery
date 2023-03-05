defmodule Rockelivery.Orders.ValidateAndMultiplyItems do
  def call(query_items, ids, params_items) do
    with {:ok, _mapped_items} = mapped_items <- check_invalid_ids(query_items, ids),
         {:ok, _multiplied_items} = multiplied_items <- multiply_items(mapped_items, params_items) do
      multiplied_items
    else
      {:error, _reason} = error -> error
    end
  end

  defp check_invalid_ids(query_items, ids) do
    mapped_items = Map.new(query_items, &{&1.id, &1})

    invalid_ids =
      ids
      |> Enum.map(fn id -> {id, Map.get(mapped_items, id)} end)
      |> Enum.any?(fn {_id, value} -> is_nil(value) end)

    case invalid_ids do
      true -> {:error, "Invalid item ids"}
      false -> {:ok, mapped_items}
    end
  end

  defp multiply_items({:error, _reason} = error, _items), do: error

  defp multiply_items({:ok, mapped_items}, params_items) do
    items_multiplied =
      Enum.reduce(params_items, [], fn %{"id" => id, "quantity" => quantity}, acc ->
        item = Map.get(mapped_items, id)
        acc ++ List.duplicate(item, quantity)
      end)

    {:ok, items_multiplied}
  end
end
