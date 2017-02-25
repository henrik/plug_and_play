defmodule Mix.Tasks.Server do
  use Mix.Task

  @shortdoc "Start the PlugAndPlay server application"

  def run(_) do
    Mix.Task.run :run, ["--no-halt"]
  end
end
