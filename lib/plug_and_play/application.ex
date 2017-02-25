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

        {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

        IO.puts "Started server: http://0.0.0.0:#{port}"

        {:ok, pid}
      end
    end
  end
end
