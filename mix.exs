defmodule TripPlanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :trip_planner,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TripPlanner.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.12"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:dotenv, "~> 3.0.0"},
      {:guardian, "~> 2.0"},
      {:argon2_elixir, "~> 2.0"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:faker, "~> 0.17", only: :test},
      {:benchee, "~> 1.0", only: :dev},
      {:uuid, "~> 1.1"},
      {:open_api_spex, "~> 3.13"},
      {:ymlr, "~> 2.0"},
      {:bodyguard, "~> 2.4"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 1.0", only: [:dev, :test], runtime: false},
      {:assertions, "~> 0.6.1", only: [:test]},
      {:money, "~> 1.11"},
      {:poison, "~> 5.0"},
      {:excoveralls, "~> 0.15", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "openapi.json": [
        "openapi.spec.json --spec TripPlannerWeb.V1.OpenApi.OpenApiSpec --pretty=true postman/schemas/openapi.json"
      ],
      "openapi.yaml": ["openapi.spec.yaml --spec TripPlannerWeb.V1.OpenApi.OpenApiSpec --pretty=true"]
    ]
  end
end
