# ExAutolink

Basic conversion of http(s) links in text to html hyperlinks.

## Features

* Convert `http://` and `https://` links to html hyperlinks (`<a>` tags)
* You can pass in entire blocks of text containing multiple links
* Pass in any extra custom attributes you want
* Respects punctuation in text so links don't break

Anti-features:

* Doesn't sanitize HTML in your text input. See
  [html_sanitize_ex](https://github.com/rrrene/html_sanitize_ex)
  if you don't control the input

## Installation

The package can be installed by adding `ex_autolink` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_autolink, "~> 0.2.0"}
  ]
end
```

## Usage

```elixir
  iex> ExAutolink.link("https://elixir-lang.org")
  "<a href=\"https://elixir-lang.org\">https://elixir-lang.org</a>"

  iex> ExAutolink.link("Go here: https://elixir-lang.org/.")
  "Go here: <a href=\"https://elixir-lang.org/\">https://elixir-lang.org/</a>."

  iex> ExAutolink.link("https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)")
  "<a href=\"https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)\">https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)</a>"

  iex> ExAutolink.link("https://elixir-lang.org!", args: %{class: "myclass active", rel: "nofollow noreferrer"})
  "<a href=\"https://elixir-lang.org\" class=\"myclass active\" rel=\"nofollow noreferrer\">https://elixir-lang.org</a>!"
```

## License

MIT.
