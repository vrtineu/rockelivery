defmodule Rockelivery.ViaCep.Response do
  @keys [:bairro, :cep, :complemento, :ddd, :gia, :ibge, :localidade, :logradouro, :siafi, :uf]
  @enforce_keys @keys

  defstruct @keys

  def new(%{
        "bairro" => bairro,
        "cep" => cep,
        "complemento" => complemento,
        "ddd" => ddd,
        "gia" => gia,
        "ibge" => ibge,
        "localidade" => localidade,
        "logradouro" => logradouro,
        "siafi" => siafi,
        "uf" => uf
      }) do
    %__MODULE__{
      bairro: bairro,
      cep: cep,
      complemento: complemento,
      ddd: ddd,
      gia: gia,
      ibge: ibge,
      localidade: localidade,
      logradouro: logradouro,
      siafi: siafi,
      uf: uf
    }
  end
end
