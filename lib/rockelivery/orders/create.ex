defmodule Rockelivery.Orders.Create do
  import Ecto.Query

  alias Rockelivery.{Error, Item, Order, Repo}
  alias Rockelivery.Orders.ValidateAndMultiplyItems

  def call(params) do
    with {:ok, multiplied_items} <- fetch_items(params),
         {:ok, %Order{}} = order <- insert_order(multiplied_items, params) do
      order
    else
      {:error, reason} -> {:error, Error.build(:bad_request, reason)}
    end
  end

  defp fetch_items(%{"items" => params_items}) do
    ids_items = Enum.map(params_items, & &1["id"])
    query = from item in Item, where: item.id in ^ids_items

    query
    |> Repo.all()
    |> ValidateAndMultiplyItems.call(ids_items, params_items)
  end

  defp insert_order(items, params_items) do
    params_items
    |> Order.changeset(items)
    |> Repo.insert()
  end
end
