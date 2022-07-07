defmodule Posts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Posts.Repo,
      # Start the Telemetry supervisor
      PostsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Posts.PubSub},
      # Start the Endpoint (http/https)
      PostsWeb.Endpoint
      # Start a worker by calling: Posts.Worker.start_link(arg)
      # {Posts.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Posts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PostsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
