defmodule G404.TranslatorTest do
  # cant make it async because one of tests modifies app environment
  use ExUnit.Case
  alias G404.Translator

  setup do
    {:ok, cache} = G404.TranslatorCache.start_link([])
    %{cache: cache}
  end

  test "translation works", %{cache: cache} do
    assert {:ok, "hi"} = Translator.translate("привет", cache)
  end

  test "translation reports errors", %{cache: cache} do
    token = Application.get_env(:g404, G404.YandexTranslate)[:token]
    Application.put_env(:g404, G404.YandexTranslate, token: "invalid")

    try do
      assert {:error, "API key is invalid"} = Translator.translate("1234", cache)
    after
      Application.put_env(:g404, G404.YandexTranslate, token: token)
    end
  end

  test "translation uses cache", %{cache: cache} do
    Translator.translate("привет", cache)
    assert {:ok, "hi"} = G404.TranslatorCache.expect(cache, "привет")

    G404.TranslatorCache.put(cache, "123", "321")
    assert {:ok, "321"} = Translator.translate("123", cache)
  end
end
