defmodule PostsWeb.PostController do
  use PostsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Posts.Social
  alias Posts.Social.Post
  alias PostsWeb.ApiSpec
  alias OpenApiSpex.{Schema, Operation, RequestBody, MediaType, Schema, Reference, Response, Link}

  action_fallback PostsWeb.FallbackController

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

  def show(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Social.get_post!(id)

    with {:ok, %Post{} = post} <- Social.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

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
          200 => %Response{
            description: "PostsList",
            content: %{
              "application/json" => %MediaType{
                schema: %Schema{
                  title: "PostsList",
                  description: "List of posts",
                  type: :object,
                  properties: %{
                    links: %Schema{
                      title: "Links",
                      description: "Pagination links",
                      type: :object,
                      properties: %{
                        prev: %Schema{type: :string},
                        next: %Schema{type: :string}
                      }
                    },
                    data: %Schema{
                      title: "PostsList",
                      description: "List of posts",
                      type: :array,
                      items: %Reference{"$ref": "#/components/schemas/Post"}
                    }
                  }
                }
              }
            },
            links: %{
              previous: %Link{
                description: "Link to the previous post page",
                operationId: "listPosts",
                parameters: %{
                  size: "The size of the page",
                  before: "The cursor for the next page"
                }
              }
            }
          }
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
        Operation.parameter(:id, :path, :integer, "The post id")
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
        Operation.parameter(:id, :path, :integer, "The post id")
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
