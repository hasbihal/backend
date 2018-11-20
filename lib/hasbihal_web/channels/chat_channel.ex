defmodule HasbihalWeb.ChatChannel do
  @moduledoc false
  use HasbihalWeb, :channel
  alias HasbihalWeb.Presence
  alias Hasbihal.{Conversations, Messages}

  @doc false
  def join("chat:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @doc false
  def join("chat:" <> _private_topic_key, payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @doc false
  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user.id, %{
      typing: false,
      name: socket.assigns.user.name
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (chat:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  @doc false
  def handle_in("user:typing", %{"typing" => typing}, socket) do
    Presence.update(socket, socket.assigns.user.id, %{
      typing: typing,
      name: socket.assigns.user.name
    })

    {:noreply, socket}
  end

  @doc false
  def handle_in("message:new", %{"message" => message}, socket) do
    user = get_in(socket.assigns, [:user])
    key = List.last(String.split(socket.topic, ":"))

    message =
      if Regex.match?(~r/^\/gif\ /, message) do
        {_command, message} = String.split_at(message, 5)

        giphy_url =
          "http://api.giphy.com/v1/gifs/translate?apikey=" <>
            System.get_env("GIPHY_API_TOKEN") <> "&s=" <> message

        {:ok, 200, _headers, client_ref} = :hackney.get(giphy_url, [], "", follow_redirect: true)
        {:ok, response} = :hackney.body(client_ref)
        response = Jason.decode!(response)

        "<img src='" <>
          response["data"]["images"]["original"]["url"] <> "' style='max-width: 200px'/>"
      else
        message
      end

    if String.length(message) > 0 &&
         Messages.create_message(%{
           message: message,
           user_id: user.id,
           conversation_id: Conversations.get_conversation_by_key!(key).id
         }) do
      broadcast!(socket, "message:new", %{user: user, message: message})
    end

    {:noreply, socket}
  end

  @doc false
  def handle_in("file:new", %{"file_id" => file_id}, socket) do
    user = get_in(socket.assigns, [:user])
    file = Hasbihal.Uploads.get_file!(file_id)

    broadcast!(socket, "file:new", %{
      user: user,
      file: %{
        file_name: file.file.file_name,
        file_url: Hasbihal.File.url({file.file.file_name, file})
      }
    })

    {:noreply, socket}
  end

  @doc false
  defp authorized?(%{"token" => token} = _payload) do
    if String.length(token) > 0, do: true, else: false
  end
end
