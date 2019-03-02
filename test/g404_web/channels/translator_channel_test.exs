defmodule G404Web.TranslatorChannelTest do
  use G404Web.ChannelCase
  alias G404Web.TranslatorChannel
  alias G404Web.Socket

  defp join do
    socket(Socket, nil, %{})
    |> subscribe_and_join(TranslatorChannel, "translator", %{})
  end

  defp join! do
    {:ok, _, socket} = join()
    socket
  end

  test "join translator channel" do
    assert {:ok, _, _} = join()
  end

  test "refutes invalid messages" do
    socket = join!()
    ref = push(socket, "message", %{"whatever" => "whatever"})
    assert_reply ref, :error, %{"reason" => "invalid_message"}, 1000
  end

  test "refutes long strings" do
    socket = join!()
    ref = push(socket, "message", %{"message" => List.to_string(List.duplicate(?a, 300))})
    assert_reply ref, :error, %{"reason" => "too_long"}, 1000
  end

  test "it works" do
    socket = join!()
    ref = push(socket, "message", %{"message" => "привет"})
    push(socket, "message", %{"message" => "гиппопотам"})
    refute_reply ref, :error, _, 200
    assert_broadcast "translation", %{"eng_message" => "hi"}, 1000
    assert_broadcast "translation", %{"eng_message" => "Hippo"}, 1000
  end
end
