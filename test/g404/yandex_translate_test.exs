defmodule G404.YandexTranslateTest do
  use ExUnit.Case, async: true
  alias G404.YandexTranslate

  test "yandex translate works" do
    assert {:ok, %HTTPoison.Response{body: %{"text" => ["hi" | _rest]}}} =
             YandexTranslate.get("привет")
  end
end
