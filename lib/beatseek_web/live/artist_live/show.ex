defmodule BeatseekWeb.ArtistLive.Show do
  use BeatseekWeb, :live_view

  alias Beatseek.Artists
  alias Beatseek.Albums
  alias Beatseek.Verification.Spotify
  import BeatseekWeb.Components.AlbumArt
  import BeatseekWeb.Components.Dropdown

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:active_tab, :artists)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    artist = Artists.get_artist!(id)
    albums = list_albums_by_artist(artist)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:artist, artist)
     |> assign(:albums, albums)
     |> assign(:album_count, Enum.count(albums))}
  end

  defp page_title(:show), do: "Show Artist"
  defp page_title(:edit), do: "Edit Artist"

  @impl true
  def handle_event("verify", %{"id" => id}, socket) do
    artist = Artists.get_artist!(id)
    {:ok, _} = Artists.update_artist(artist, %{verified_at: nil})
    Spotify.verify(id)
    {:ok, _} = Artists.update_artist(artist, %{verified_at: DateTime.utc_now()})
    {:noreply, socket}
  end

  defp list_albums_by_artist(artist) do
    Albums.list_albums_by_artist(artist)
  end
end
