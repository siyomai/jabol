defmodule Jabol.MixProject do
  use Mix.Project

  def project do
    [
      app: :jabol,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "Jabol",
      source_url: "https://github.com/yourusername/jabol"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:jason, "~> 1.4", optional: true},
      {:postgrex, "~> 0.17", optional: true},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Jabol is a lightweight schema and data persistence library for Elixir applications.
    It provides a simple API for defining schemas, managing database connections, and performing CRUD operations.
    """
  end

  defp package do
    [
      name: "jabol",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yourusername/jabol"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      groups_for_modules: [
        Core: [
          Jabol.Schema,
          Jabol.Repo
        ],
        Testing: [
          Jabol.Factory
        ],
        Configuration: [
          Jabol.Config.Database
        ]
      ]
    ]
  end
end
