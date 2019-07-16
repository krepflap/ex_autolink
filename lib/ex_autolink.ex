defmodule ExAutolink do
  @moduledoc """
  This simple module is used for converting http(s):// links in text to
  HTML hyperlinks.

  It doesn't depend on Phoenix.HTML, but can be used in conjuction with Phoenix.
  """

  @doc ~S"""
  This method is used for parsing strings or text blocks. We convert all links
  starting with http:// or https:// to HTML links.

  ## Examples

      iex> ExAutolink.link("https://elixir-lang.org")
      "<a href=\"https://elixir-lang.org\">https://elixir-lang.org</a>"

      iex> ExAutolink.link("Go here: https://elixir-lang.org/.")
      "Go here: <a href=\"https://elixir-lang.org/\">https://elixir-lang.org/</a>."

      iex> ExAutolink.link("https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)")
      "<a href=\"https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)\">https://ja.wikipedia.org/wiki/Elixir_(プログラミング言語)</a>"

      iex> ExAutolink.link("https://elixir-lang.org!", args: %{class: "myclass active", rel: "nofollow noreferrer"})
      "<a href=\"https://elixir-lang.org\" class=\"myclass active\" rel=\"nofollow noreferrer\">https://elixir-lang.org</a>!"

  """
  def link(text, options \\ [])
  def link("", _options), do: ""
  def link(text, []), do: build_link(text)
  def link(text, args: args), do: build_link(text, build_arguments(args))

  defp build_link(text, extra \\ <<>>) do
    Regex.replace(~r{(https?://[^\s]+)}, text, fn url ->
      {:ok, url_part, punctuation} =
        url
        |> reverse()
        |> parse_punctuation()

      ~s(<a href="#{url_part}"#{extra}>#{url_part}</a>#{punctuation})
    end)
  end

  # parse_punctuation/2 is used to handle punctuation by recursively scanning
  # the string in reversed order. It is used to split punctuation from the
  # actual url (trailing full stop, question marks, etc. i.e. anything not
  # part of the url itself).
  defp parse_punctuation(reversed, punctuation \\ <<>>)

  # This matches cases when punctuation contains any kind of closing bracket.
  defp parse_punctuation(<<?), reversed::binary>>, punctuation),
    do: parse_brackets(reversed, punctuation, ?(, ?))

  defp parse_punctuation(<<?], reversed::binary>>, punctuation),
    do: parse_brackets(reversed, punctuation, ?[, ?])

  defp parse_punctuation(<<?}, reversed::binary>>, punctuation),
    do: parse_brackets(reversed, punctuation, ?{, ?})

  defp parse_punctuation(<<last_char, reversed::binary>>, punctuation) do
    if <<last_char>> =~ ~r/^[^\p{L}\p{N}\/-=&]$/ do
      # The regex is used to match on punctuation characters.
      #
      # Anything that is NOT a letter, number, forward slash, dash, equal sign,
      # or ampersand, is matched. We thus assume it is punctuation.
      parse_punctuation(reversed, punctuation <> <<last_char>>)
    else
      {:ok, reverse(<<last_char>> <> reversed), reverse(punctuation)}
    end
  end

  defp parse_brackets(reversed, punctuation, opening, closing) do
    # We use find_opening/2 to search if there is a matching opening bracket
    # earlier in the string.
    case find_opening(reversed, opening, closing) do
      {:found} -> {:ok, reverse(<<closing>> <> reversed), reverse(punctuation)}
      {:not_found} -> parse_punctuation(reversed, punctuation <> <<closing>>)
    end
  end

  defp find_opening(<<>>, _opening, _closing), do: {:not_found}

  defp find_opening(<<last_char, reversed::binary>>, opening, closing) do
    # Recursively look for the first encountered opening bracket, without
    # stumbling upon another closing bracket.
    case last_char do
      ^opening -> {:found}
      ^closing -> {:not_found}
      _ -> find_opening(reversed, opening, closing)
    end
  end

  defp build_arguments(args) when is_map(args) do
    for {k, v} <- args, into: "", do: ~s( #{k}="#{v}")
  end

  defp reverse(binary, result \\ <<>>)
  defp reverse(<<>>, result), do: result
  defp reverse(<<c::utf8, rest::binary>>, result), do: reverse(rest, <<c::utf8>> <> result)
end
