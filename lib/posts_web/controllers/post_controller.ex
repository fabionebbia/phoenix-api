defmodule PostsWeb.PostController do
  use PostsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Posts.Social
  alias Posts.Social.Post
  alias OpenApiSpex.Schema
  alias PostsWeb.Schemas

  action_fallback PostsWeb.FallbackController

  tags ["posts"]

  operation :index,
    summary: "Lists posts",
    description: "Lists all posts",
    parameters: [
      size: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The maximum number of posts to include per page",
        example: 10,
        required: false
      ],
      before: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The cursor used to retrieve posts that come before the given post id",
        example: 3451,
        required: false
      ],
      after: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The cursor used to retrieve posts that come after the given post id",
        example: 3451,
        required: false
      ]
    ],
    responses: [
      ok: {"Post List Response", "application/json", Schemas.PostsResponse}
    ]

  def index(conn, params) do
    posts = Social.list_posts(params)
    render(conn, "index.json", posts: posts, params: params)
  end

  operation :create,
    summary: "Create a post",
    description: "Create a new post",
    parameters: [],
    request_body:
      {"The post attributes", "application/json", Schemas.PostRequest, required: true},
    responses: [
      created: {"Post", "application/json", Schemas.PostResponse}
    ]

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Social.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  operation :show,
    summary: "Show post",
    description: "Show a post by id",
    paramters: [
      id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ]
    ],
    responses: [
      ok: {"Post", "application/json", Schemas.PostResponse}
    ]

  def show(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    render(conn, "show.json", post: post)
  end

  operation :update,
    summary: "Update post",
    description: "Update a post by id",
    paramters: [
      id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ]
    ],
    request_body:
      {"The post attributes", "application/json", Schemas.PostRequest, required: true},
    responses: [
      ok: {"Post", "application/json", Schemas.PostResponse}
    ]

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Social.get_post!(id)

    with {:ok, %Post{} = post} <- Social.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  operation :delete,
    summary: "Delete post",
    description: "Delete a post by id",
    parameters: [
      id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ]
    ],
    # TODO
    responses: []

  def delete(conn, %{"id" => id}) do
    post = Social.get_post!(id)

    with {:ok, %Post{}} <- Social.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
