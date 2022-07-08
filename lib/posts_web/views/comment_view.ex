defmodule PostsWeb.CommentView do
  use PostsWeb, :view
  alias PostsWeb.CommentView
  alias PostsWeb.Endpoint
  alias PostsWeb.Router.Helpers, as: Routes

  def render("index.json", %{comments: []}) do
    %{data: render_many([], CommentView, "comment.json")}
  end

  def render("index.json", %{comments: comments, params: params}) do
    {min, max} =
      comments
      |> Enum.map(fn comment -> Map.get(comment, :id) end)
      |> Enum.min_max()

    post_id = Map.get(params, "post_id")
    params = Map.delete(params, "post_id")
    params_prev = Map.put(params, :before, min) |> Map.delete("after")
    params_next = Map.put(params, :after, max) |> Map.delete("before")

    %{
      data: render_many(comments, CommentView, "comment.json"),
      links: %{
        prev: "#{Routes.post_comment_path(Endpoint, :index, post_id, params_prev)}",
        next: "#{Routes.post_comment_path(Endpoint, :index, post_id, params_next)}"
      }
    }
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      author: comment.author,
      post_id: comment.post_id
    }
  end
end
