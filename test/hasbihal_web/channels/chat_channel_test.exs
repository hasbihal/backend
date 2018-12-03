defmodule HasbihalWeb.ChatChannelTest do
  @moduledoc false
  use HasbihalWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      socket(HasbihalWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(HasbihalWeb.ChatChannel, "chat:lobby")

    {:ok, socket: socket}
  end
end
