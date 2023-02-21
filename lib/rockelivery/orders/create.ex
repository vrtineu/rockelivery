defmodule Rockelivery.Orders.Create do
  import Ecto.Query

  alias Rockelivery.{Error, Item, Order, Repo}

  def call(params) do
    with {:ok, items_multiplied} <- fetch_items(params),
         {:ok, %Order{}} = order <- insert_order(items_multiplied, params) do
      order
    else
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end

  defp fetch_items(%{"items" => items}) do
    ids = Enum.map(items, & &1["id"])
    query = from item in Item, where: item.id in ^ids

    query
    |> Repo.all()
    |> check_invalid_items(ids)
    |> multiply_items(items)
  end

  defp check_invalid_items(items, ids) do
    map_items = Map.new(items, &{&1.id, &1})

    ids
    |> Enum.map(fn id -> {id, Map.get(map_items, id)} end)
    |> Enum.any?(fn {_id, value} -> is_nil(value) end)
    |> case do
      true -> {:error, "There are invalid ids"}
      false -> {:ok, map_items}
    end
  end

  defp multiply_items({:error, result}, _items), do: {:error, result}

  defp multiply_items({:ok, map_items}, items) do
    items_multiplied =
      Enum.reduce(items, [], fn %{"id" => id, "quantity" => quantity}, acc ->
        item = Map.get(map_items, id)
        acc ++ List.duplicate(item, quantity)
      end)

    {:ok, items_multiplied}
  end

  defp insert_order(items, params) do
    params
    |> Order.changeset(items)
    |> Repo.insert()
  end
end
