defmodule G404.Translator do
  @moduledoc """
  Translates given phrase via Yandex.Translate,
  using cached result if available
  """

  @doc "Translate the given phrase"
  @spec translate(String.t()) :: {:error, any()} | {:ok, String.t()}
  def translate(phrase) do
    G404.TranslatorCache.get_or_fill(phrase)
  end
end
