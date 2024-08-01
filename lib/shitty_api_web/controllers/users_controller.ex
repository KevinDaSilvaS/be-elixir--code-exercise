defmodule SampleApiWeb.UsersController do
  use SampleApiWeb, :controller

  def fetch_users(conn, params) do
    search_opts = Users.Validator.parse(params)
    conn |> put_status(200) |> json(UserService.fetch_users(search_opts))
  end
end
