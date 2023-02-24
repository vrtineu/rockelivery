defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User
  alias Rockelivery.ViaCep.Response

  def user_params_factory do
    %{
      "age" => 30,
      "address" => "Rua das Flores",
      "cep" => "12345678",
      "cpf" => "12345678901",
      "email" => "teste@email.com",
      "password" => "12345678",
      "name" => "Teste"
    }
  end

  def user_factory do
    %User{
      age: 30,
      address: "Rua das Flores",
      cep: "12345678",
      cpf: "12345678901",
      email: "teste@email.com",
      password: "12345678",
      name: "Teste",
      id: "221d42a5-bef6-45fd-9a65-fe0be10edad4"
    }
  end

  def cep_info_factory do
    %Response{
      bairro: "Sé",
      cep: "01001-000",
      complemento: "lado ímpar",
      ddd: "11",
      gia: "1004",
      ibge: "3550308",
      localidade: "São Paulo",
      logradouro: "Praça da Sé",
      siafi: "7107",
      uf: "SP"
    }
  end
end
