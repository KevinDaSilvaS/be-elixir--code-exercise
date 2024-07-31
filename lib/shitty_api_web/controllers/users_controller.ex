defmodule ShittyApiWeb.UsersController do
  use ShittyApiWeb, :controller

  def fetch_users(conn, params) do

    render(conn, :home, layout: false)
  end
end
