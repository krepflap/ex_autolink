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

  """
  def link(""), do: ""

  def link(text) do
    Regex.replace(~r{(https?://[^\s]+)}, text, fn x ->
      {:ok, url_part, punctuation} = x |> reverse() |> parse_punctuation()

      ~s(<a href="#{url_part}">#{url_part}</a>#{punctuation})
    end)
  end

  defp parse_punctuation(<<last_char, reversed :: binary>>, punctuation \\ "") do
    if <<last_char>> =~ ~r/^[^\p{L}\p{N}\/-=&]$/ do
      parse_punctuation(reversed, punctuation <> <<last_char>>)
    else
      {:ok, reverse(<<last_char>> <> reversed), reverse(punctuation)}
    end
  end

  defp reverse(""), do: ""

  defp reverse(binary) do
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end
end
