defmodule Hasbihal.MixProject do
  use Mix.Project

  def project do
    [
      app: :hasbihal,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # Docs
      name: "Hasbihal",
      source_url: "https://github.com/hasbihal/backend",
      homepage_url: "https://hasbihal.com",
      docs: [
        # The main page in the docs
        main: "Hasbihal",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Hasbihal.Application, []},
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
      {:phoenix, "~> 1.4.0-rc", override: true},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 3.5"},
      {:ecto, "~> 3.0-rc", override: true},
      {:ecto_sql, "~> 3.0-rc", override: true},
      {:postgrex, ">= 0.0.0-rc"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2-rc", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:guardian, "~> 1.1"},
      {:comeonin, "~> 4.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "format --check-formatted",
        "credo --strict",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ],
      check: "sobelow --verbose"
    ]
  end
end