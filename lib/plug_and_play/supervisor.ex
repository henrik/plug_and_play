defmodule PlugAndPlay.Supervisor do
  use Supervisor

  def start_link(root_module) do
    router = Module.concat [root_module, "Router"]  # E.g. HelloWorld.Router

    app = Application.get_application(root_module)  # E.g. :hello_world
    port_in_app_config = Application.get_env(app, :port)
    port = port_in_app_config || String.to_integer(System.get_env("PORT") || "8080")

    case Supervisor.start_link(__MODULE__, [router, port]) do
      {:ok, pid} ->
        IO.puts "PlugAndPlay started server: http://0.0.0.0:#{port}"
        {:ok, pid }
      # Wrap hard-to-read errors in nicer ones.
      {:error, {:shutdown, {:failed_to_start_child, _, {:shutdown, {:failed_to_start_child, _, {:listen_error, _, :eaddrinuse}}}}}} ->
        puts_error "PlugAndPlay could not start server: port #{port} is in use!"
        {:error, {:port_in_use, port}}
      {:error, {:undef, [{router, :init, [[]], []}|_]}} ->
        puts_error "PlugAndPlay could not find router module: expected #{inspect router} to be defined!"
        {:error, {:router_not_found, router}}
    end
  end

  def init([router, port]) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, router, [], port: port),
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp puts_error(message) do
    IO.puts :stderr, [IO.ANSI.red, IO.ANSI.bright, "\n#{message}", IO.ANSI.reset]
  end
end
