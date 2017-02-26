defmodule PlugAndPlay.Application do
  defmacro __using__(opts) do
    root_module = Keyword.fetch!(opts, :mod)

    quote do
      use Application

      def start(_type, _args) do
        PlugAndPlay.Supervisor.start_link(unquote(root_module))
      end
    end
  end
end
