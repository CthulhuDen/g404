defmodule G404.TranslatorCache do
  @moduledoc """
  Process keeps track of translation cache
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :start, [{:name, __MODULE__} | opts])
  end

  @doc """
  Fetch the result from cache, or, if this `phrase` was never translated before,
  execute the calculation then store and return it's result.
  """
  @spec get_or_fill(String.t()) :: {:ok, String.t()} | {:error, any()}
  def get_or_fill(phrase) do
    GenServer.call(__MODULE__, {:get_or_fill, phrase})
  end

  @doc """
  If `phrase` is already translated, or already in translation, it will wait
  for the translation and return it. Otherwise returns :error.
  """
  @spec expect(String.t()) :: {:ok, String.t()} | :error
  def expect(phrase) do
    GenServer.call(__MODULE__, {:expect, phrase})
  end

  @doc """
  Stores `translation` for given `phrase`.
  """
  @spec put(String.t(), String.t()) :: :ok
  def put(phrase, translation) do
    GenServer.call(__MODULE__, {:put, phrase, translation})
  end

  def init(:start) do
    {:ok, {%{}, %{}}}
  end

  def handle_call({:expect, phrase}, from, {translations, tasks} = state) do
    case Map.fetch(translations, phrase) do
      {:ok, {:translated, translation}} ->
        {:reply, {:ok, translation}, state}

      {:ok, {:progress, pids}} ->
        {:noreply, {%{translations | phrase => {:progress, [from | pids]}}, tasks}}

      :error ->
        {:reply, :error, state}
    end
  end

  def handle_call({:put, phrase, translation}, _from, {translations, tasks}) do
    translations = put_translation(translations, phrase, translation)

    {:reply, :ok, {translations, tasks}}
  end

  def handle_call({:get_or_fill, phrase}, from, {translations, tasks} = state) do
    case Map.fetch(translations, phrase) do
      {:ok, {:translated, translation}} ->
        {:reply, {:ok, translation}, state}

      {:ok, {:progress, pids}} ->
        {:noreply, {%{translations | phrase => {:progress, [from | pids]}}, tasks}}

      :error ->
        %Task{ref: ref} = G404.TranslatorCache.Supervisor.translate(phrase)
        translations = Map.put(translations, phrase, {:progress, [from]})
        tasks = Map.put(tasks, ref, phrase)
        {:noreply, {translations, tasks}}
    end
  end

  def handle_info({ref, {:ok, translation}}, {translations, tasks}) when is_reference(ref) do
    # We don't care about the DOWN message now, so let's demonitor and flush it
    Process.demonitor(ref, [:flush])

    phrase = Map.fetch!(tasks, ref)
    tasks = Map.delete(tasks, ref)

    translations = put_translation(translations, phrase, translation)
    {:noreply, {translations, tasks}}
  end

  defp put_translation(translations, phrase, translation) do
    case Map.fetch(translations, phrase) do
      {:ok, {:progress, pids}} ->
        Enum.each(pids, &GenServer.reply(&1, {:ok, translation}))
        %{translations | phrase => {:translated, translation}}

      _ ->
        Map.put(translations, phrase, {:translated, translation})
    end
  end
end
