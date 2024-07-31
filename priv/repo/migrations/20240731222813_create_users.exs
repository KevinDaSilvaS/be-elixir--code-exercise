defmodule ShittyApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute """
      create table users (
        user_id serial primary key,
        name varchar not null,
        salary integer not null,
        currency varchar not null,
        active bool not null default True
      );
    """
  end

  def down do
    execute "drop table users;"
  end
end
