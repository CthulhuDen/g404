defmodule G404.TranslatorTest do
  use ExUnit.Case, async: true
  alias G404.Translator

  test "translation works" do
    assert {:ok, "hi"} = Translator.translate("привет")
  end

  @tag :pending
  test "translation uses cache" do
    Translator.translate("привет")
    assert {:ok, "hi"} = G404.TranslatorCache.fetch("привет")

    G404.TranslatorCache.put("123", "321")
    assert {:ok, "321"} = Translator.translate("123")
  end
end
