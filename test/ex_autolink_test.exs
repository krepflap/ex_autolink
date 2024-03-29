defmodule ExAutolinkTest do
  use ExUnit.Case, async: true
  doctest ExAutolink

  @simple [
    "https://www.yahoo.com",
    "https://www.google.be",
    "https://whatever.xyz",
    "http://insecure.org"
  ]

  @arguments [
    "https://www.eff.org/deeplinks/2019/06/felony-contempt-business-model-lexmarks-anti-competitive-legacy",
    "https://www.google.be/?param=1&param=2",
    "https://www.twitch.tv/directory/game/Just%20Chatting",
    "http://insecure.org/",
    "https://eff.org/"
  ]

  @brackets [
    "https://en.wikipedia.org/wiki/Sprite_(computer_graphics)",
    "https://en.wikipedia.org/wiki/Sprite_[computer_graphics]",
    "https://en.wikipedia.org/wiki/Sprite_{computer_graphics}"
  ]

  @japanese [
    "https://ja.wikipedia.org/wiki/メインページ",
    "https://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%A4%E3%83%B3%E3%83%9A%E3%83%BC%E3%82%B8"
  ]

  describe "simple url conversions" do
    test "should work with empty string" do
      assert ExAutolink.link("") == ""
    end

    test "should work on urls" do
      Enum.map(@simple, &assert_link/1)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, &assert_link/1)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, &assert_link/1)
    end

    test "should work on urls with foreign characters" do
      Enum.map(@japanese, &assert_link/1)
    end
  end

  describe "conversions of url within simple text" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert ExAutolink.link("Check out #{x} !") == "Check out #{urlify(x)} !"
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert ExAutolink.link("Check out #{x} !") == "Check out #{urlify(x)} !"
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert ExAutolink.link("Check out #{x} !") == "Check out #{urlify(x)} !"
      end)
    end

    test "should work on urls with foreign characters" do
      Enum.map(@japanese, fn x ->
        assert ExAutolink.link("Check out #{x} !") == "Check out #{urlify(x)} !"
      end)
    end
  end

  describe "conversions of url with trailing punctuation" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert ExAutolink.link("Check out #{x}.") == "Check out #{urlify(x)}."
        assert ExAutolink.link("Check out #{x}!") == "Check out #{urlify(x)}!"
        assert ExAutolink.link("Check out #{x}, ...") == "Check out #{urlify(x)}, ..."
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert ExAutolink.link("Check out #{x}.") == "Check out #{urlify(x)}."
        assert ExAutolink.link("Check out #{x}!") == "Check out #{urlify(x)}!"
        assert ExAutolink.link("Check out #{x}, ...") == "Check out #{urlify(x)}, ..."
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert ExAutolink.link("Check out #{x}.") == "Check out #{urlify(x)}."
        assert ExAutolink.link("Check out #{x}!") == "Check out #{urlify(x)}!"
        assert ExAutolink.link("Check out #{x}, ...") == "Check out #{urlify(x)}, ..."
      end)
    end

    test "should work on urls with foreign characters" do
      Enum.map(@japanese, fn x ->
        assert ExAutolink.link("Check out #{x}.") == "Check out #{urlify(x)}."
        assert ExAutolink.link("Check out #{x}!") == "Check out #{urlify(x)}!"
        assert ExAutolink.link("Check out #{x}, ...") == "Check out #{urlify(x)}, ..."
      end)
    end
  end

  describe "conversions of url in text surrounded by brackets" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert ExAutolink.link("Check out (#{x})") == "Check out (#{urlify(x)})"
        assert ExAutolink.link("(Check out #{x})") == "(Check out #{urlify(x)})"
        assert ExAutolink.link("Check out [#{x}]") == "Check out [#{urlify(x)}]"
        assert ExAutolink.link("Check out {#{x}}") == "Check out {#{urlify(x)}}"
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert ExAutolink.link("Check out (#{x})") == "Check out (#{urlify(x)})"
        assert ExAutolink.link("(Check out #{x})") == "(Check out #{urlify(x)})"
        assert ExAutolink.link("Check out [#{x}]") == "Check out [#{urlify(x)}]"
        assert ExAutolink.link("Check out {#{x}}") == "Check out {#{urlify(x)}}"
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert ExAutolink.link("Check out (#{x})") == "Check out (#{urlify(x)})"
        assert ExAutolink.link("(Check out #{x})") == "(Check out #{urlify(x)})"
        assert ExAutolink.link("Check out [#{x}]") == "Check out [#{urlify(x)}]"
        assert ExAutolink.link("Check out {#{x}}") == "Check out {#{urlify(x)}}"
      end)
    end

    test "should work on urls with foreign characters" do
      Enum.map(@brackets, fn x ->
        assert ExAutolink.link("Check out (#{x})") == "Check out (#{urlify(x)})"
        assert ExAutolink.link("(Check out #{x})") == "(Check out #{urlify(x)})"
        assert ExAutolink.link("Check out [#{x}]") == "Check out [#{urlify(x)}]"
        assert ExAutolink.link("Check out {#{x}}") == "Check out {#{urlify(x)}}"
      end)
    end
  end

  describe "multiple urls in text" do
    test "should work as expected" do
      expected =
        ~s(check out #{urlify("https://www.yahoo.com")}, or #{urlify("https://bing.com")}!)

      actual = ExAutolink.link("check out https://www.yahoo.com, or https://bing.com!")
      assert actual == expected
    end
  end

  describe "passing extra arguments" do
    test "should work with one argument" do
      url = "https://www.yahoo.co.uk/"
      expected = ~s(<a href="#{url}" class="myclass">#{url}</a>)
      assert ExAutolink.link(url, args: %{class: "myclass"}) == expected
    end
  end

  defp urlify(link), do: ~s(<a href="#{link}">#{link}</a>)
  defp assert_link(link), do: assert(ExAutolink.link(link) == urlify(link))
end
