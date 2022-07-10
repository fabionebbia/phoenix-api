defmodule Posts.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Posts.Repo

  alias Posts.Social.{Post, Comment}

  @default_page_size 5

  def list_posts(params) do
    query =
      case params do
        %{"before" => cursor} -> from p in Post, where: p.id < ^cursor, order_by: [desc: p.id]
        %{"after" => cursor} -> from p in Post, where: p.id > ^cursor
        _ -> from(p in Post)
      end

    size = Map.get(params, "size", @default_page_size)
    query = limit(query, ^size)
    Repo.all(query)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def list_comments(post, params) do
    query =
      case params do
        %{"before" => cursor} ->
          from c in Comment, where: c.post_id == ^post and c.id < ^cursor, order_by: [desc: c.id]

        %{"after" => cursor} ->
          from c in Comment, where: c.post_id == ^post and c.id > ^cursor

        _ ->
          from c in Comment, where: c.post_id == ^post
      end

    size = Map.get(params, "size", @default_page_size)
    query = limit(query, ^size)
    Repo.all(query)
  end

  def get_comment!(post_id, comment_id) do
    query = from(Comment, where: [post_id: ^post_id, id: ^comment_id])
    Repo.one!(query)
  end

  def create_comment(post, attrs \\ %{}) do
    attrs = Map.put(attrs, "post_id", post)

    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(post, %Comment{} = comment, attrs) do
    attrs = Map.put(attrs, "post_id", post)

    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(post, comment) do
    query = from(Comment, where: [post_id: ^post, id: ^comment])
    Repo.delete_all(query)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
