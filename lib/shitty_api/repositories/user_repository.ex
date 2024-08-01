defmodule UserRepository do
  def fetch_users(%{search: nil, page: pg, itens_per_page: offset}) do
    IO.inspect("No search")
    query = """
      SELECT name, salary
      FROM users
      ORDER BY name ASC
      LIMIT $1::integer
      OFFSET $2::integer;
      """

    Ecto.Adapters.SQL.query!(ShittyApi.Repo, query, [offset, ((pg-1)*offset)])
    |> Map.get(:rows, [])
  end

  def fetch_users(%{search: srch, page: pg, itens_per_page: offset}) do
    query = """
      SELECT name, salary
      FROM users WHERE name @@ to_tsquery($1)
      ORDER BY name ASC
      LIMIT $2::integer
      OFFSET $3::integer;
      """

    Ecto.Adapters.SQL.query!(ShittyApi.Repo, query, [srch, offset, ((pg-1)*offset)])
    |> Map.get(:rows, [])

  end
end
