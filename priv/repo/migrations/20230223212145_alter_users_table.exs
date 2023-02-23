defmodule Rockelivery.Repo.Migrations.AlterUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :city, :string
      add :uf, :string
    end
  end
end
