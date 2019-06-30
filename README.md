# ExAutolink

Simple conversion of http(s) links in text to html hyperlinks.

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

## Features

* Convert http:// and https:// links to html hyperlinks (`<a>` tags)
* Pass in any extra custom attributes you want
* Respects punctuation in text so links don't break

## License

MIT
