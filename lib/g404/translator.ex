defmodule G404.Translator do
  @moduledoc """
  Translates given phrase via Yandex.Translate,
  using cached result if available
  """

  @doc "Translate the given phrase"
  @spec translate(String.t()) :: {:error, any()} | {:ok, String.t()}
  def translate(phrase) do
    yandex_translate(phrase)
  end

  defp yandex_translate(phrase) do
    with {:ok, %HTTPoison.Response{body: body}} <- G404.YandexTranslate.get(phrase) do
      case body do
        %{"text" => [translation | _rest]} ->
          {:ok, translation}

        %{"message" => message} ->
          {:error, message}

        _ ->
          {:error, body}
      end
    end
  end
end
