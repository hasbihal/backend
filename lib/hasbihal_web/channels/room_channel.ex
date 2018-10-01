defmodule HasbihalWeb.RoomChannel do
  @moduledoc false

  use HasbihalWeb, :channel

  alias Hasbihal.Users

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    user_id = get_in(socket.assigns, [:user_id])

    username =
      if is_nil(user_id) do
        payload["sender"]
      else
        Users.get_user!(user_id).name
      end

    broadcast!(socket, "message:new", %{user: username, message: payload["message"]})

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
