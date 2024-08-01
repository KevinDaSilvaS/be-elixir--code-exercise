defmodule Users.Validator do
  def parse(req_data) do
    %{
      search: Map.get(req_data, "search", nil),
      page: Map.get(req_data, "page", "1") |> String.to_integer(),
      itens_per_page: Map.get(req_data, "itens_per_page", "10") |> String.to_integer()
    }
  end
end
