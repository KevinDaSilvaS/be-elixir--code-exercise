defmodule Users.Validator do
  def validate(req_body) do
    name = Map.has_key?(params, "name")
    salary = Map.has_key?(params, "salary")
  end
end
