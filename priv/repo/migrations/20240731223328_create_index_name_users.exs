defmodule ShittyApi.Repo.Migrations.CreateIndexNameUsers do
  use Ecto.Migration

  def change do
    create index(:users, [:name])
  end
end
