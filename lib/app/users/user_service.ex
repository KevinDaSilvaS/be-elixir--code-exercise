defmodule UserService do
  import Ecto.Query
  def fetch_users(search_data) do
    UserRepository.fetch_users(search_data)
    |> Enum.map(fn [name, salary] ->
      %{
        name: name,
        salary: salary
      }
    end)
  end
end
