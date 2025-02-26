defmodule Blockchain.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Configuration pour ExCoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Blockchain.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},      # Serveur HTTP
      {:jason, "~> 1.4"},            # JSON encoding/decoding
      {:poison, "~> 5.0"},           # Alternative JSON library
      {:ex_crypto, "~> 0.10.0"},     # Cryptographie
      {:ex_doc, "~> 0.29", only: :dev}, # Documentation
      {:credo, "~> 1.7", only: [:dev, :test]}, # Linter
      {:excoveralls, "~> 0.15", only: :test}   # Test coverage
    ]
  end
end
