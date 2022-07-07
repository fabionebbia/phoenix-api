defmodule PostsWeb.CommentController do
  use PostsWeb, :controller

  alias Posts.Social
  alias Posts.Social.Comment

  action_fallback PostsWeb.FallbackController

  def index(conn, %{} = a) do
    IO.inspect(a)
    comments = Social.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"post_id" => post, "comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Social.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_comment_path(conn, :show, post, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Social.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Social.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Social.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Social.get_comment!(id)

    with {:ok, %Comment{}} <- Social.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
