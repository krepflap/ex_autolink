# ExAutolink

Basic conversion of http(s) links in text to html hyperlinks.

## Features

* Convert http:// and https:// links to html hyperlinks (`<a>` tags)
* Pass in any extra custom attributes you want
* Respects punctuation in text so links don't break

## Installation

The package can be installed by adding `ex_autolink` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_autolink, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
  iex> ExAutolink.link("https://elixir-lang.org")
  "<a href=\"https://elixir-lang.org\">https://elixir-lang.org</a>"

  iex> ExAutolink.link("Go here: https://elixir-lang.org/.")
  "Go here: <a href=\"https://elixir-lang.org/\">https://elixir-lang.org/</a>."
```

## License

MIT.
