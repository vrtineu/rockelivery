defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  alias Rockelivery.Error
  alias Rockelivery.ViaCep.{Client, Response}

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "when there is a valid CEP, returns the CEP info", %{bypass: bypass} do
      url = endpoint_url(bypass.port)
      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      cep = "01001000"

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:ok,
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
         }}

      assert response == expected_response
    end

    test "when the cep has an invalid length, returns an error", %{bypass: bypass} do
      url = endpoint_url(bypass.port)

      cep = "123"

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.resp(400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{status: :bad_request, result: "Bad request"}}

      assert response == expected_response
    end

    test "when the cep is not found, returns an error", %{bypass: bypass} do
      url = endpoint_url(bypass.port)
      body = ~s({"erro": true})

      cep = "00000000"

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{status: :not_found, result: "CEP not found"}}

      assert response == expected_response
    end

    test "when there is a generic error, returns an error", %{bypass: bypass} do
      url = endpoint_url(bypass.port)

      cep = "00000000"

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{status: :bad_request, result: :econnrefused}}

      assert response == expected_response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
