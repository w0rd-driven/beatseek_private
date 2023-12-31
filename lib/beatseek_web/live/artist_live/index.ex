defmodule BeatseekWeb.ArtistLive.Index do
  use BeatseekWeb, :live_view

  alias Beatseek.Artists
  alias Beatseek.Artists.Artist

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:artists, list_artists()) |> assign(:active_tab, :artists)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Artist")
    |> assign(:artist, Artists.get_artist!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Artist")
    |> assign(:artist, %Artist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Artists")
    |> assign(:artist, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    artist = Artists.get_artist!(id)
    {:ok, _} = Artists.delete_artist(artist)

    {:noreply, assign(socket, :artists, list_artists())}
  end

  defp list_artists do
    Artists.list_artists()
  end
end
