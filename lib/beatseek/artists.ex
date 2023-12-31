defmodule Beatseek.Artists do
  @moduledoc """
  The Artists context.
  """

  import Ecto.Query, warn: false
  alias Beatseek.Repo

  alias Beatseek.Artists.Artist

  @doc """
  Returns the list of artists.

  ## Examples

      iex> list_artists()
      [%Artist{}, ...]

  """
  def list_artists do
    Artist
    |> order_by(asc: :name)
    |> Repo.all()
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!(123)
      %Artist{}

      iex> get_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist!(id), do: Repo.get!(Artist, id)

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert(on_conflict: {:replace_all_except, [:id]}, conflict_target: [:name])
  end

  @doc """
  Updates a artist.

  ## Examples

      iex> update_artist(artist, %{field: new_value})
      {:ok, %Artist{}}

      iex> update_artist(artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a artist.

  ## Examples

      iex> delete_artist(artist)
      {:ok, %Artist{}}

      iex> delete_artist(artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.

  ## Examples

      iex> change_artist(artist)
      %Ecto.Changeset{data: %Artist{}}

  """
  def change_artist(%Artist{} = artist, attrs \\ %{}) do
    Artist.changeset(artist, attrs)
  end

  @doc """
  Returns a count of artists.

  ## Examples

      iex> get_artist_count()
      0

  """
  def get_artist_count() do
    Artist
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns the next id to backfill.

  ## Examples

      iex> get_next_backfill_id()
      1

  """
  def get_next_backfill_id(current_id \\ 0) do
    Artist
    |> where([artist], is_nil(artist.verified_at))
    |> where([artist], artist.id > ^current_id)
    |> order_by(asc: :id)
    |> limit(1)
    |> select([artist], artist.id)
    |> Repo.one()
  end

  @doc """
  Updates all artist `verified_at` columns to `NULL` to reset the backfill process.

  ## Examples

      iex> reset_verified()
      1

  """
  def reset_verified() do
    Artist
    |> Repo.update_all(set: [verified_at: nil])
  end
end
