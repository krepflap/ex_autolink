defmodule ExAutolink.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_autolink,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ExAutolink",
      description: "Elixir library for generating html hyperlinks from text",
      package: package(),
      source_url: "https://github.com/krepflap/ex_autolink"
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
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "ex_autolink",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/krepflap/ex_autolink"}
    ]
  end
end
