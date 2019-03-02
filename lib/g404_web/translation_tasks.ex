defmodule G404Web.TranslationTasks do
  @moduledoc """
  Uses supervisor for translation jobs asked by socket clients.
  """

  alias G404.Translator

  @doc """
  Start async task translating the phrase,
  then apply the callback to the result.
  """
  def translate(phrase, then) do
    # We do not want caller process to be linked or even receive computation result, so
    Task.Supervisor.start_child(__MODULE__, fn ->
      case Translator.translate(phrase) do
        {:ok, phrase} ->
          then.(phrase)

        _ ->
          :whatever
      end
    end)
  end
end
