defmodule G404.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      G404Web.Endpoint,
      {Task.Supervisor, name: G404Web.TranslationTasks},
      {G404.TranslatorCache, name: G404.TranslatorCache},
      {Task.Supervisor, name: G404.TranslatorCache.Supervisor}
    ]

    opts = [strategy: :one_for_all, name: G404.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    G404Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
