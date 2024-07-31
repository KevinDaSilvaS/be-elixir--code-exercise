defmodule ShittyApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShittyApiWeb.Telemetry,
      ShittyApi.Repo,
      {DNSCluster, query: Application.get_env(:shitty_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ShittyApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ShittyApi.Finch},
      # Start a worker by calling: ShittyApi.Worker.start_link(arg)
      # {ShittyApi.Worker, arg},
      # Start to serve requests, typically the last entry
      ShittyApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShittyApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShittyApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
