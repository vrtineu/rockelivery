defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      age: 30,
      address: "Rua das Flores",
      cep: "12345678",
      cpf: "12345678901",
      email: "teste@email.com",
      password: "12345678",
      name: "Teste"
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
end
