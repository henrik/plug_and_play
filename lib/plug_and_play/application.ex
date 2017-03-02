defmodule PlugAndPlay.Application do
  defmacro __using__(opts) do
    router = Keyword.fetch!(opts, :router)
    port = Keyword.get(opts, :port)

    quote do
      use Application

      def start(_type, _args) do
        PlugAndPlay.Supervisor.start_link(unquote(router), unquote(port))
      end
    end
  end
end
