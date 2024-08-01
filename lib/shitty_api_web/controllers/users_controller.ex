defmodule SampleApiWeb.UsersController do
  use SampleApiWeb, :controller

  def fetch_users(conn, params) do
    search_opts = Users.Validator.parse(params)
    conn |> put_status(200) |> json(UserService.fetch_users(search_opts))
  end

  def mail_active_users(conn, _params) do
    Phoenix.PubSub.broadcast(:mailer_pubsub, "request", %{offset: 0, limit: 10})
    conn |> put_status(200) |> json(%{ok: "Mail request sent successfully"})
  end
end
