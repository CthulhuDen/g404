defmodule G404Web.TranslatorChannel do
  @moduledoc """
  Translates messages using yandex.translate
  """

  use Phoenix.Channel
  alias G404Web.TranslationTasks

  def join("translator", _message, socket), do: {:ok, socket}

  def handle_in(_event, %{"message" => msg}, socket) when is_binary(msg) do
    if String.length(msg) > 200 do
      {:reply, {:error, %{"reason" => "too_long"}}, socket}
    else
      TranslationTasks.translate(msg, fn translation ->
        # let it fail, it's in async task anyway
        broadcast!(socket, "translation", %{"eng_message" => translation})
      end)

      {:noreply, socket}
    end
  end

  def handle_in(_event, _payload, socket) do
    {:reply, {:error, %{"reason" => "invalid_message"}}, socket}
  end
end
