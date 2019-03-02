defmodule G404.YandexTranslate do
  @moduledoc """
  API client for Yandex.Translate.
  Configure this modules's keyword :token.
  """

  use HTTPoison.Base

  def process_request_url(phrase) do
    query =
      URI.encode_query(
        key: Application.get_env(:g404, __MODULE__)[:token],
        text: phrase,
        lang: "ru-en"
      )

    "https://translate.yandex.net/api/v1.5/tr.json/translate?#{query}"
  end

  def process_response_body(body) do
    Poison.decode!(body)
  end
end
