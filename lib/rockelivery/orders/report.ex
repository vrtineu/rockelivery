defmodule Rockelivery.Orders.Report do
  import Ecto.Query

  alias Rockelivery.{Item, Order, Repo}
  alias Rockelivery.Orders.TotalPrice

  @default_batch_size 500

  def create(filename \\ "report.csv") do
    with {:ok, orders} <- fetch_orders(),
         :ok <- File.write!(filename, orders) do
      {:ok, filename}
    end
  end

  defp fetch_orders do
    query = from order in Order, order_by: order.user_id

    Repo.transaction(
      fn ->
        query
        |> Repo.stream(max_rows: @default_batch_size)
        |> Stream.chunk_every(@default_batch_size)
        |> Stream.flat_map(fn chunk -> Repo.preload(chunk, :items) end)
        |> Enum.map(&to_csv/1)
      end
      # timeout: :infinity, because the default timeout is 15000ms
    )
  end

  defp to_csv(%Order{user_id: user_id, payment_method: payment_method, items: items}) do
    total_price = TotalPrice.calculate(items)
    parsed_items = Enum.map(items, &items_to_csv/1)
    "#{user_id},#{payment_method},#{parsed_items}#{total_price}\n"
  end

  defp items_to_csv(%Item{category: category, description: description, price: price}) do
    "#{category},#{description},#{price},"
  end
end
