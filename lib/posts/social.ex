defmodule Posts.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Posts.Repo

  alias Posts.Social.Post

  @default_page_size 5

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(params) do
    query =
      case params do
        %{"before" => cursor} -> from p in Post, where: p.id < ^cursor
        %{"after" => cursor} -> from p in Post, where: p.id > ^cursor
        _ -> from(p in Post)
      end

    size = Map.get(params, "size", @default_page_size)
    query = limit(query, ^size)
    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Posts.Social.Comment

  def list_comments(post, params) do
    query =
      case params do
        %{"before" => cursor} -> from c in Comment, where: c.post_id == ^post and c.id < ^cursor
        %{"after" => cursor} -> from c in Comment, where: c.post_id == ^post and c.id > ^cursor
        _ -> from c in Comment, where: c.post_id == ^post
      end

    size = Map.get(params, "size", @default_page_size)
    query = limit(query, ^size)
    Repo.all(query)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(post_id, comment_id) do
    query = from(Comment, where: [post_id: ^post_id, id: ^comment_id])
    Repo.one!(query)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(post, attrs \\ %{}) do
    attrs = Map.put(attrs, "post_id", post)

    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(post, %Comment{} = comment, attrs) do
    attrs = Map.put(attrs, "post_id", post)

    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(post, comment) do
    query = from(Comment, where: [post_id: ^post, id: ^comment])
    Repo.delete_all(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
