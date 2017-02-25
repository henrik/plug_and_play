defmodule PlugAndPlay.Supervisor do
  use Supervisor

  def start_link(router) do
    port = String.to_integer(System.get_env("PORT") || "8080")

    case Supervisor.start_link(__MODULE__, [router, port]) do
      {:ok, pid} ->
        IO.puts "PlugAndPlay started server: http://0.0.0.0:#{port}"
        {:ok, pid }
      {:error, {:shutdown, {:failed_to_start_child, _, {:shutdown, {:failed_to_start_child, _, {:listen_error, _, :eaddrinuse}}}}}} ->
        IO.puts :stderr, [IO.ANSI.red, IO.ANSI.bright, "\nPlugAndPlay could not start server: port #{port} is in use!", IO.ANSI.reset]
        {:error, {:port_in_use, port}}
    end
  end

  def init([router, port]) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, router, [], port: port),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
