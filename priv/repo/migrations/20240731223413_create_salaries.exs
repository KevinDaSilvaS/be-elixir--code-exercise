defmodule SampleApi.Repo.Migrations.CreateSalaries do
  use Ecto.Migration

  def up do
    execute """
      create table salaries (
        salary_id serial primary key,
        salary integer not null,
        currency varchar not null,
        user_id integer not null references users(user_id)
      );
    """
  end

  def down do
    execute "drop table salaries;"
  end
end
