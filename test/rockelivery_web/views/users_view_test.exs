defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory
  alias RockeliveryWeb.UsersView

  test "renders create.json" do
    user = build(:user)
    token = "xpto123"
    response = render(UsersView, "create.json", token: token, user: user)

    assert %{
             message: "User created successfully",
             token: "xpto123",
             user: %Rockelivery.User{
               id: "221d42a5-bef6-45fd-9a65-fe0be10edad4",
               address: "Rua das Flores",
               age: 30,
               cep: "12345678",
               cpf: "12345678901",
               email: "teste@email.com",
               name: "Teste",
               password: "12345678",
               password_hash: nil,
               inserted_at: nil,
               updated_at: nil
             }
           } = response
  end
end
