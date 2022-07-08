defmodule PostsWeb.PostController do
  use PostsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Posts.Social
  alias Posts.Social.Post
  alias OpenApiSpex.Schema
  alias PostsWeb.ApiSpec
  alias OpenApiSpex.{Operation, RequestBody, MediaType, Schema, Reference}

  action_fallback PostsWeb.FallbackController

  # tags ["posts"]

  # operation :index,
  #   summary: "Lists posts",
  #   description: "Lists all posts",
  #   parameters: [
  #     size: [
  #       in: :query,
  #       type: %Schema{type: :integer, minimum: 0},
  #       description: "The maximum number of posts to include per page",
  #       example: 10,
  #       required: false
  #     ],
  #     before: [
  #       in: :query,
  #       type: %Schema{type: :integer, minimum: 0},
  #       description: "The cursor used to retrieve posts that come before the given post id",
  #       example: 3451,
  #       required: false
  #     ],
  #     after: [
  #       in: :query,
  #       type: %Schema{type: :integer, minimum: 0},
  #       description: "The cursor used to retrieve posts that come after the given post id",
  #       example: 3451,
  #       required: false
  #     ]
  #   ],
  #   responses: [
  #     ok: {"Post List Response", "application/json", Schemas.PostsResponse}
  #   ]

  def index(conn, params) do
    posts = Social.list_posts(params)
    render(conn, "index.json", posts: posts, params: params)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Social.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  # operation :show,
  #   summary: "Show post",
  #   description: "Show a post by id",
  #   paramters: [
  #     id: [
  #       in: :path,
  #       type: %Schema{type: :integer, minimum: 1},
  #       description: "The post id",
  #       example: 3245,
  #       required: true
  #     ]
  #   ],
  #   responses: [
  #     ok: {"Post", "application/json", Schemas.PostResponse}
  #   ]

  def show(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    render(conn, "show.json", post: post)
  end

  # operation :update,
  #   summary: "Update post",
  #   description: "Update a post by id",
  #   paramters: [
  #     id: [
  #       in: :path,
  #       type: %Schema{type: :integer, minimum: 1},
  #       description: "The post id",
  #       example: 3245,
  #       required: true
  #     ]
  #   ],
  #   request_body:
  #     {"The post attributes", "application/json", Schemas.PostRequest, required: true},
  #   responses: [
  #     ok: {"Post", "application/json", Schemas.PostResponse}
  #   ]

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Social.get_post!(id)

    with {:ok, %Post{} = post} <- Social.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  # operation :delete,
  #   summary: "Delete post",
  #   description: "Delete a post by id",
  #   parameters: [
  #     id: [
  #       in: :path,
  #       type: %Schema{type: :integer, minimum: 1},
  #       description: "The post id",
  #       example: 3245,
  #       required: true
  #     ]
  #   ],
  #   # TODO
  #   responses: []

  def delete(conn, %{"id" => id}) do
    post = Social.get_post!(id)

    with {:ok, %Post{}} <- Social.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end

  # OpenAPI specs

  def open_api_operation(action) do
    apply(__MODULE__, :"#{action}_operation", [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["posts"],
      summary: "Show all posts",
      description: "Show all posts created by users.",
      operationId: "listPosts",
      responses:
        %{
          200 =>
            Operation.response(
              "PostsList",
              "application/json",
              %Schema{
                title: "PostsList",
                description: "List of posts",
                type: :array,
                items: %Reference{"$ref": "#/components/schemas/Post"}
              }
            )
        }
        |> ApiSpec.common_read_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec show_operation() :: Operation.t()
  def show_operation do
    %Operation{
      tags: ["posts"],
      summary: "Show a post",
      description: "Show post details by id.",
      operationId: "showPost",
      parameters: [
        Operation.parameter(:id, :path, :integer, "Post id")
      ],
      responses:
        %{
          200 => Operation.response("PostResponse", "application/json", PostsWeb.Schemas.Post)
        }
        |> ApiSpec.common_read_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["posts"],
      summary: "Create a new post",
      description: "Create a new post from json encoded parameters in request body.",
      operationId: "createPost",
      requestBody: %RequestBody{
        content: %{"application/json" => %MediaType{schema: PostsWeb.Schemas.Post}},
        description: "Post Object input data",
        required: true
      },
      responses:
        %{
          201 => Operation.response("PostResponse", "application/json", PostsWeb.Schemas.Post)
        }
        |> ApiSpec.common_write_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec put_operation() :: Operation.t()
  def put_operation do
    update_operation()
    |> Map.put(:operationId, "replacePost")
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["posts"],
      summary: "Update an existing post",
      description: "Update an existing post by id",
      operationId: "updatePost",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          :integer,
          "Post id"
        )
      ],
      requestBody: %RequestBody{
        content: %{"application/json" => %MediaType{schema: PostsWeb.Schemas.Post}},
        description: "Post Object input data",
        required: true
      },
      responses:
        %{
          201 => Operation.response("PostResponse", "application/json", PostsWeb.Schemas.Post)
        }
        |> ApiSpec.common_write_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["posts"],
      summary: "Delete an existing post",
      description: "Delete an existing post by id",
      operationId: "deletePost",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          :integer,
          "Post id"
        )
      ],
      responses:
        %{
          204 => Operation.response("PostResponse", "application/json", nil)
        }
        |> ApiSpec.common_read_responses()
        |> ApiSpec.response(404)
    }
  end
end
