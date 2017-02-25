defmodule PlugAndPlay.Application do
  defmacro __using__(opts) do
    router = Keyword.fetch!(opts, :router)

    quote do
      use Application

      def start(_type, _args) do
        PlugAndPlay.Supervisor.start_link(unquote(router))
      end
    end
  end
end
