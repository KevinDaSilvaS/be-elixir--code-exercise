defmodule ShittyApi.Repo do
  use Ecto.Repo,
    otp_app: :shitty_api,
    adapter: Ecto.Adapters.Postgres
end
