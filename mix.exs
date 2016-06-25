defmodule Mondo.Mixfile do
  use Mix.Project

  def project do
    [app: :mondo,
     version: "0.2.0",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: description,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    applications = [:logger, :httpoison]

    applications = if Mix.env == :test do
      [:ex_machina] ++ applications
    else
      applications
    end

    [applications: applications]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8"},
     {:plug, "~> 1.1"},
     {:poison, "~> 2.2"},
     {:ex_machina, "~> 0.6.1", only: :test},
     {:bypass, "~> 0.5", only: :test}]
  end

  defp description do
    """
    An Elixir client for the Mondo API.
    """
  end

  defp package do
    [maintainers: ["Steve Domin"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/stevedomin/mondo_elixir"}]
  end
end
