defmodule HasbihalWeb.ChatChannel do
  @moduledoc false
  use HasbihalWeb, :channel

  def join("chat:lobby", payload, socket) do
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
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    user = get_in(socket.assigns, [:user])
    broadcast!(socket, "message:new", %{user: user.name, message: payload["message"]})
    {:noreply, socket}
  end

  defp authorized?(payload) do
    if Map.get(payload, "token") != "" do
      true
    else
      false
    end
  end
end
