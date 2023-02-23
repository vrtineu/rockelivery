defmodule Rockelivery.Users.Create do
  alias Ecto.Changeset

  alias Rockelivery.{Error, Repo, User}
  alias Rockelivery.ViaCep.Client
  alias Rockelivery.ViaCep.Response

  def call(%{"cep" => cep} = params) do
    case Client.get_cep_info(cep) do
      {:ok, %Response{} = cep_response} -> merge_cep_info(params, cep_response)
      {:error, _reason} = error -> error
    end
  end

  defp merge_cep_info(params, %Response{localidade: city, uf: uf}) do
    params
    |> Map.put("city", city)
    |> Map.put("uf", uf)
    |> create_user()
  end

  defp create_user(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, %Changeset{} = result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
