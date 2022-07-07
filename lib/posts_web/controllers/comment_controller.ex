defmodule PostsWeb.CommentController do
  use PostsWeb, :controller

  alias Posts.Social
  alias Posts.Social.Comment

  action_fallback PostsWeb.FallbackController

  def index(conn, %{"post_id" => post}) do
    comments = Social.list_comments(post)
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"post_id" => post, "comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Social.create_comment(post, comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_comment_path(conn, :show, post, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"post_id" => post, "comment_id" => id}) do
    comment = Social.get_comment!(post, id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"post_id" => post, "comment_id" => comment_id, "comment" => comment_params}) do
    comment = Social.get_comment!(post, comment_id)

    with {:ok, %Comment{} = comment} <- Social.update_comment(post, comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"post_id" => post, "comment_id" => comment}) do
    with {:ok, %Comment{}} <- Social.delete_comment(post, comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
