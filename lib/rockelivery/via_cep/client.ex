defmodule Rockelivery.ViaCep.Client do
  use Tesla

  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Response

  alias Tesla.Env

  @base_url "https://viacep.com.br/ws/"

  plug Tesla.Middleware.JSON

  def get_cep_info(url \\ @base_url, cep) do
    "#{url}#{cep}/json"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Env{status: 200, body: %{"erro" => true}}}) do
    {:error, Error.build(:not_found, "CEP not found")}
  end

  defp handle_response({:ok, %Env{status: 400}}) do
    {:error, Error.build(:bad_request, "Bad request")}
  end

  defp handle_response({:error, reason}) do
    {:error, Error.build(:bad_request, reason)}
  end

  defp handle_response({:ok, %Env{status: 200, body: body}}), do: {:ok, Response.new(body)}
end
