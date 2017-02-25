defmodule PlugAndPlay.Application do
  defmacro __using__(opts) do
    router = Keyword.fetch!(opts, :router)

    quote do
      use Application
      import Supervisor.Spec

      def start(_type, _args) do
        children = [
          supervisor(PlugAndPlay.Supervisor, [unquote(router)]),
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end
  end
end
