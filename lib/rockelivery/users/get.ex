defmodule Rockelivery.Users.Get do
  alias Rockelivery.{Error, Repo, User}

  # def by_id(id) do
  #   with {:ok, uuid} <- UUID.cast(id),
  #        {:ok, user} <- get(uuid) do
  #     {:ok, user}
  #   else
  #     :error -> {:error, %{status: :bad_request, result: "Invalid id"}}
  #     nil -> {:error, %{status: :not_found, result: "User not found"}}
  #   end
  # end

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found()}
      user -> {:ok, user}
    end
  end
end
