defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Item

  def calculate(items) do
    Enum.reduce(items, Decimal.new("0.00"), &sum/2)
  end

  defp sum(%Item{price: price}, acc), do: Decimal.add(acc, price)
end
