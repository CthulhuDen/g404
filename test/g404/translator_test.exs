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

    {:ok, another_cache} = G404.TranslatorCache.start_link([])
    G404.TranslatorCache.put(another_cache, "привет", "hello")
    assert {:ok, "hello"} = Translator.translate("привет", another_cache)

    # Make sure original cache was not affected
    assert {:ok, "hi"} = Translator.translate("привет", cache)
  end
end
