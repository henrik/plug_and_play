defmodule PlugAndPlay.Application do
  defmacro __using__(opts) do
    router = Keyword.fetch!(opts, :router)

    quote do
      use Application

      def start(_type, _args) do
        port = String.to_integer(System.get_env("PORT") || "8080")

        children = [
          Plug.Adapters.Cowboy.child_spec(:http, unquote(router), [], port: port),
        ]

        case Supervisor.start_link(children, strategy: :one_for_one) do
          {:ok, pid} ->
            IO.puts "PlugAndPlay started server: http://0.0.0.0:#{port}"
            {:ok, pid }
          {:error, {:shutdown, {:failed_to_start_child, _, {:shutdown, {:failed_to_start_child, _, {:listen_error, _, :eaddrinuse}}}}}} ->
            IO.puts :stderr, [IO.ANSI.red, IO.ANSI.bright, "\nPlugAndPlay could not start server: port #{port} is in use!", IO.ANSI.reset]
            {:error, {:port_in_use, port}}
        end
      end
    end
  end
end
