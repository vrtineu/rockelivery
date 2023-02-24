defmodule RockeliveryWeb.UserControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.ViaCep.ClientMock

  describe "create/2" do
    test "when all params are valid, returns the user", %{conn: conn} do
      params = %{
        "age" => 30,
        "address" => "Rua das Flores",
        "cep" => "12345678",
        "cpf" => "12345678901",
        "email" => "teste@email.com",
        "password" => "12345678",
        "name" => "Teste"
      }

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(:created)

      assert %{
               "message" => "User created successfully",
               "user" => %{
                 "address" => "Rua das Flores",
                 "age" => 30,
                 "cep" => "12345678",
                 "cpf" => "12345678901",
                 "email" => "teste@email.com",
                 "id" => _id,
                 "name" => "Teste"
               }
             } = response
    end

    test "when there are some errors, returns the errors", %{conn: conn} do
      params = %{
        "password" => "12345678",
        "name" => "Teste"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create), params)
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "address" => ["can't be blank"],
          "age" => ["can't be blank"],
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end

  describe "delete/2" do
    test "when there is a user with the given id, deletes the user", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, user.id))
        |> response(:no_content)

      assert response == ""
    end
  end
end
