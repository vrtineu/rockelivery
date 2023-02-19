defmodule Rockelivery do
  defdelegate create_user(params), to: Rockelivery.Users.Create, as: :call
  defdelegate get_user(id), to: Rockelivery.Users.Get, as: :by_id
  defdelegate delete_user(id), to: Rockelivery.Users.Delete, as: :call
  defdelegate update_user(params), to: Rockelivery.Users.Update, as: :call

  defdelegate create_item(params), to: Rockelivery.Items.Create, as: :call
end
