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

  @doc false
  def handle_in("user:typing", %{"typing" => typing}, socket) do
    Presence.update(socket, socket.assigns.user.id, %{
      typing: typing,
      name: socket.assigns.user.name
    })

    {:noreply, socket}
  end

  @doc false
  def handle_in("message:new", %{"message" => message, "gif" => true}, socket) do
    user = get_in(socket.assigns, [:user])
    {_command, message} = String.split_at(message, 5)

    try do
      message = "#{message}\n" <> get_random_gif(message)

      save_message(
        List.last(String.split(socket.topic, ":")),
        user,
        message
      )

      broadcast!(socket, "message:new", %{user: user, message: message})
    rescue
      e in RuntimeError ->
        broadcast!(socket, "message:new", %{
          user: user,
          message: e.message <> "\n<small><em>This message only visible for you...</em></small>",
          visible_only_id: user.id
        })
    end

    {:noreply, socket}
  end

  @doc false
  def handle_in("message:new", %{"message" => message}, socket) do
    user = get_in(socket.assigns, [:user])

    if String.length(message) > 0 do
      try do
        save_message(
          List.last(String.split(socket.topic, ":")),
          user,
          message
        )

        broadcast!(socket, "message:new", %{user: user, message: message})
      rescue
        e in RuntimeError ->
          broadcast!(socket, "message:new", %{
            user: user,
            message:
              e.message <> "\n<small><em>This message only visible for you...</em></small>",
            visible_only_id: user.id
          })
      end
    end

    {:noreply, socket}
  end

  @doc false
  def handle_in("file:new", %{"file_id" => file_id}, socket) do
    file = Hasbihal.Uploads.get_file!(file_id)

    broadcast!(socket, "file:new", %{
      user: get_in(socket.assigns, [:user]),
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

  @doc false
  defp get_random_gif(message) do
    giphy_url =
      "http://api.giphy.com/v1/gifs/translate?apikey=" <>
        System.get_env("GIPHY_API_TOKEN") <> "&s=" <> message

    case :hackney.get(giphy_url, [], "", follow_redirect: true) do
      {:ok, 200, _headers, client_ref} ->
        {:ok, response} = :hackney.body(client_ref)
        response = Jason.decode!(response)

        "<img width='200' src='#{response["data"]["images"]["fixed_width_small"]["url"]}'/>"

      _ ->
        raise "Sorry! An error occurred your gif could not be shown."
    end
  end

  @doc false
  defp save_message(key, user, message) do
    case Messages.create_message(%{
           message: message,
           user_id: user.id,
           conversation_id: Conversations.get_conversation_by_key!(key).id
         }) do
      {:ok, message} -> message
      {:error, reason} -> raise "Your message could not sent, because: " <> reason
    end
  end
end
