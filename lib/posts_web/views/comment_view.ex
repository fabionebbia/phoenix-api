defmodule PostsWeb.CommentView do
  use PostsWeb, :view
  alias PostsWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
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
