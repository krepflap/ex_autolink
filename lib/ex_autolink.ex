defmodule ExAutolink do
  @moduledoc """
  This simple module is used for converting http(s):// links in text to
  HTML hyperlinks.

  It doesn't depend on Phoenix.HTML, but can be used in conjuction with Phoenix.
  """

  @brackets %{?) => ?(, ?] => ?[, ?} => ?{}

  @doc ~S"""
  This method is used for parsing strings or text blocks. We convert all links
  starting with http:// or https:// to HTML links.

  ## Examples

      iex> ExAutolink.link("https://elixir-lang.org")
      "<a href=\"https://elixir-lang.org\">https://elixir-lang.org</a>"

      iex> ExAutolink.link("Go here: https://elixir-lang.org/.")
      "Go here: <a href=\"https://elixir-lang.org/\">https://elixir-lang.org/</a>."

  """
  def link(""), do: ""

  def link(text) do
    Regex.replace(~r{(https?://[^\s]+)}, text, fn x ->
      {:ok, url_part, punctuation} = x |> reverse() |> parse_punctuation()

      ~s(<a href="#{url_part}">#{url_part}</a>#{punctuation})
    end)
  end

  # parse_punctuation/2 is used to handle punctuation by recursively scanning
  # the string in reversed order. It is used to split punctuation from the
  # actual url (trailing full stop, question marks, etc. i.e. anything not
  # part of the url itself).
  defp parse_punctuation(reversed, punctuation \\ <<>>)

  # This matches cases when punctuation contains a closing bracket.
  defp parse_punctuation(<<?), reversed::binary>>, punctuation),
    do: parse_brackets(")" <> reversed, punctuation)

  defp parse_punctuation(<<?], reversed::binary>>, punctuation),
    do: parse_brackets("]" <> reversed, punctuation)

  defp parse_punctuation(<<?}, reversed::binary>>, punctuation),
    do: parse_brackets("}" <> reversed, punctuation)

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

  defp parse_brackets(<<last_char, reversed::binary>>, punctuation) do
    # We use find_opening/2 to check if there is a matching opening bracket
    # earlier in the string.
    case find_opening(reversed, last_char) do
      {:found} -> {:ok, reverse(<<last_char>> <> reversed), reverse(punctuation)}
      {:not_found} -> parse_punctuation(reversed, punctuation <> <<last_char>>)
    end
  end

  defp find_opening(<<>>, _closing), do: {:not_found}

  defp find_opening(<<last_char, reversed::binary>>, closing) do
    # Get the corresponding opening bracket from the map defined above.
    opening = Map.get(@brackets, closing)

    # Look for the first encountered opening bracket, without stumbling upon
    # another closing bracket.
    case last_char do
      ^opening -> {:found}
      ^closing -> {:not_found}
      _ -> find_opening(reversed, closing)
    end
  end

  defp reverse(<<>>), do: ""

  defp reverse(binary) do
    # This seems to be an efficient way to reverse a string.
    # https://gist.github.com/evadne/33805e13f1d84eb2e32f0d1e1a376899
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end
end
