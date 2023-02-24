defmodule Rockelivery.Users.Create do
  alias Ecto.Changeset

  alias Rockelivery.{Error, Repo, User}
  alias Rockelivery.ViaCep.{Client, Response}

  def call(%{"cep" => cep} = params) do
    changeset = User.changeset(params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, %Response{} = cep_response} <- Client.get_cep_info(cep),
         {:ok, %{} = user} <- merge_cep_info(changeset, cep_response),
         {:ok, %User{} = user_created} <- Repo.insert(user) do
      {:ok, user_created}
    else
      {:error, %Error{}} = error -> error
      {:error, reason} -> {:error, Error.build(:bad_request, reason)}
    end
  end

  defp merge_cep_info(%Changeset{} = changeset, %Response{localidade: city, uf: uf}) do
    {:ok,
     changeset
     |> Changeset.put_change(:city, city)
     |> Changeset.put_change(:uf, uf)}
  end
end
