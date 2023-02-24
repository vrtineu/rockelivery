defmodule Rockelivery.ViaCep.Behaviour do
  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Response

  @typep client_result :: {:ok, Response.t()} | {:error, Error.t()}

  @callback get_cep_info(String.t()) :: client_result
  @callback get_cep_info(String.t(), String.t()) :: client_result
end
