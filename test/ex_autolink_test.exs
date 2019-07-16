defmodule ExAutolinkTest do
  use ExUnit.Case
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

  describe "simple url conversions" do
    test "should work with empty string" do
      assert "" == ExAutolink.link("")
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
  end

  describe "conversions of url within simple text" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert "Check out #{urlify(x)} !" == ExAutolink.link("Check out #{x} !")
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert "Check out #{urlify(x)} !" == ExAutolink.link("Check out #{x} !")
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert "Check out #{urlify(x)} !" == ExAutolink.link("Check out #{x} !")
      end)
    end
  end

  describe "conversions of url with trailing punctuation" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert "Check out #{urlify(x)}." == ExAutolink.link("Check out #{x}.")
        assert "Check out #{urlify(x)}!" == ExAutolink.link("Check out #{x}!")
        assert "Check out #{urlify(x)}, ..." == ExAutolink.link("Check out #{x}, ...")
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert "Check out #{urlify(x)}." == ExAutolink.link("Check out #{x}.")
        assert "Check out #{urlify(x)}!" == ExAutolink.link("Check out #{x}!")
        assert "Check out #{urlify(x)}, ..." == ExAutolink.link("Check out #{x}, ...")
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert "Check out #{urlify(x)}." == ExAutolink.link("Check out #{x}.")
        assert "Check out #{urlify(x)}!" == ExAutolink.link("Check out #{x}!")
        assert "Check out #{urlify(x)}, ..." == ExAutolink.link("Check out #{x}, ...")
      end)
    end
  end

  describe "conversions of url in text surrounded by brackets" do
    test "should work on urls" do
      Enum.map(@simple, fn x ->
        assert "Check out (#{urlify(x)})" == ExAutolink.link("Check out (#{x})")
        assert "(Check out #{urlify(x)})" == ExAutolink.link("(Check out #{x})")
        assert "Check out [#{urlify(x)}]" == ExAutolink.link("Check out [#{x}]")
        assert "Check out {#{urlify(x)}}" == ExAutolink.link("Check out {#{x}}")
      end)
    end

    test "should work on urls with trailing path or arguments" do
      Enum.map(@arguments, fn x ->
        assert "Check out (#{urlify(x)})" == ExAutolink.link("Check out (#{x})")
        assert "(Check out #{urlify(x)})" == ExAutolink.link("(Check out #{x})")
        assert "Check out [#{urlify(x)}]" == ExAutolink.link("Check out [#{x}]")
        assert "Check out {#{urlify(x)}}" == ExAutolink.link("Check out {#{x}}")
      end)
    end

    test "should work on urls with brackets" do
      Enum.map(@brackets, fn x ->
        assert "Check out (#{urlify(x)})" == ExAutolink.link("Check out (#{x})")
        assert "(Check out #{urlify(x)})" == ExAutolink.link("(Check out #{x})")
        assert "Check out [#{urlify(x)}]" == ExAutolink.link("Check out [#{x}]")
        assert "Check out {#{urlify(x)}}" == ExAutolink.link("Check out {#{x}}")
      end)
    end
  end

  describe "multiple urls in text" do
    test "should work as expected" do
      expected = ~s(check out #{urlify("https://www.yahoo.com")}, or #{urlify("https://bing.com")}!)
      actual = ExAutolink.link("check out https://www.yahoo.com, or https://bing.com!")
      assert expected == actual
    end
  end

  defp urlify(link), do: ~s(<a href="#{link}">#{link}</a>)
  defp assert_link(link), do: assert(urlify(link) == ExAutolink.link(link))
end
