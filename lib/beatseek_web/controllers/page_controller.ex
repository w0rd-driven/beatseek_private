defmodule BeatseekWeb.PageController do
  use BeatseekWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def music(conn, _params) do
    # We unfortunately need layout:false here
    # conn
    # |> assign(:active_tab, :artists)
    # |> render(:music, layout: false)
    conn
    |> assign(:active_tab, :artists)
    |> redirect(to: ~p"/artists")
  end
end
