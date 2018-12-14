defmodule ExComposerBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_composer_bot,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
      mod: {ExComposerBot.Application, []}
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
      # Project dependencies
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.7", only: :test},
      # TODO remove
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},

      # Tests
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:ex_parameterized, "~> 1.3.0", only: :test, runtime: false},

      # Runtime dependencies
      {:ex_structable, "~> 0.4.0"}
    ]
  end

  defp aliases do
    [
      check: ["test", "credo"]
    ]
  end

  defp preferred_cli_env do
    [
      # Aliases
      check: :test,
      # Coveralls
      coveralls: :test,
      "coveralls.travis": :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test
    ]
  end
end
