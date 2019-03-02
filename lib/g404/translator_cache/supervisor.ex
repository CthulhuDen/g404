defmodule G404.TranslatorCache.Supervisor do
  @moduledoc """
  This supervisor holds all active translations for cache process.
  """

  def translate(phrase) do
    Task.Supervisor.async(__MODULE__, fn -> yandex_translate(phrase) end)
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
