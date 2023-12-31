defmodule BeatseekWeb.NotificationLive.Show do
  use BeatseekWeb, :live_view

  alias Beatseek.Notifications

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [active_tab: nil]}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:notification, Notifications.get_notification!(id))}
  end

  defp page_title(:show), do: "Show Notification"
  defp page_title(:edit), do: "Edit Notification"
end
