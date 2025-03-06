defmodule PrahaStehuje.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PrahaStehujeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:prahaStehuje, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PrahaStehuje.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PrahaStehuje.Finch},
      # Start a worker by calling: PrahaStehuje.Worker.start_link(arg)
      # {PrahaStehuje.Worker, arg},
      # Start to serve requests, typically the last entry
      PrahaStehujeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PrahaStehuje.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PrahaStehujeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
