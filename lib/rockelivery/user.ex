defmodule Rockelivery.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Rockelivery.Order

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :email, :age, :address, :cep, :cpf, :password]
  @update_params @required_params -- [:password]

  @derive {Jason.Encoder, only: @required_params ++ [:id, :inserted_at, :updated_at, :city, :uf]}

  schema "users" do
    field :address, :string
    field :age, :integer
    field :cep, :string
    field :city, :string
    field :cpf, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :uf, :string

    has_many :orders, Order

    timestamps()
  end

  def build(changeset), do: apply_action(changeset, :create)

  def changeset(params) do
    %__MODULE__{}
    |> changes(@required_params, params)
  end

  def changeset(struct, params) do
    struct
    |> changes(@update_params, params)
  end

  defp changes(struct, fields, params) do
    struct
    |> cast(params, fields ++ [:city, :uf])
    |> validate_required(fields)
    |> validate_length(:password, min: 6)
    |> validate_length(:cep, min: 8)
    |> validate_length(:cpf, min: 11)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
