defmodule PostsWeb.PostView do
  use PostsWeb, :view
  alias PostsWeb.PostView
  alias PostsWeb.Endpoint
  alias PostsWeb.Router.Helpers, as: Routes

  def render("index.json", %{posts: []}) do
    %{data: render_many([], PostView, "post.json")}
  end

  def render("index.json", %{posts: posts, params: params}) do
    {min, max} =
      posts
      |> Enum.map(fn post -> Map.get(post, :id) end)
      |> Enum.min_max()

    params_prev = Map.put(params, :before, min) |> Map.delete("after")
    params_next = Map.put(params, :after, max) |> Map.delete("before")

    %{
      data: render_many(posts, PostView, "post.json"),
      links: %{
        prev: "#{Routes.post_path(Endpoint, :index, params_prev)}",
        next: "#{Routes.post_path(Endpoint, :index, params_next)}"
      }
    }
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      body: post.body,
      author: post.author
    }
  end
end
