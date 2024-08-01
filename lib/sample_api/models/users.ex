defmodule Models.Users do
  use Ecto.Schema

  schema "users" do
    field :user_id, :integer
    field :name, :string
    field :salary, :integer
    field :currency, :string
    field :active, :boolean
  end
end
