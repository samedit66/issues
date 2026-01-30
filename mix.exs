defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      name: "issues",
      source_url: "https://github.com/samedit66/issues.git",
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:httpoison, "~> 2.0"},
      {:poison, "~> 6.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  defp escript_config do
    [
      main_module: Issues.CLI
    ]
  end
end
