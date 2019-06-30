defmodule ExAutolink do
  @moduledoc """
  This simple module is used for converting http(s):// links in text to
  HTML hyperlinks.

  It doesn't depend on Phoenix.HTML, but can be used in conjuction with Phoenix.
  """

  @doc """
  This method is used for parsing strings or text blocks. We convert all links
  starting with http:// or https:// to HTML links.

  ## Examples

      iex> ExAutolink.link("Go here: https://elixir-lang.org/.")
      "Go here: <a href=\"https://elixir-lang.org/\">https://elixir-lang.org/</a>."

  """
  def link(""), do: ""

  def link(text) do
    parse = fn uri, url ->
      ~s(<a href="#{uri}#{url}">#{uri}#{url}</a>)
    end

    Regex.replace(~r{(https?://)([^\s\<]+)}, text, parse.("\\1", "\\2"))
  end

  defp reverse(binary) do
    binary
    |> :binary.decode_unsigned(:little)
    |> :binary.encode_unsigned(:big)
  end
end
