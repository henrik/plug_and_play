defmodule PlugAndPlay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_and_play,
       version: "0.1.0",
       elixir: "~> 1.4",
       build_embedded: Mix.env == :prod,
       start_permanent: Mix.env == :prod,
       description: description(),
       package: package(),
       deps: deps(),
     ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [
        :logger,
      ],
    ]
  end

  defp description do
    """
    Set up a `Plug` application with less boilerplate.

    `PlugAndPlay` is not a web framework – it's a scaffold. You use `Plug` as you would normally, only *sooner*.

    Later, if you need more control, you can easily replace `PlugAndPlay` piece by piece or wholesale.
    """
  end

  defp package do
    [
      name: :plug_and_play,
      maintainers: ["Henrik Nyh"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/henrik/plug_and_play",
      },
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.1"},
    ]
  end
end
