defmodule PostsWeb.CommentController do
  use PostsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Posts.Social
  alias Posts.Social.Comment
  alias PostsWeb.ApiSpec
  alias OpenApiSpex.{Schema, Operation, RequestBody, MediaType, Schema, Reference, Response, Link}

  action_fallback PostsWeb.FallbackController

  def index(conn, %{"post_id" => post} = params) do
    comments = Social.list_comments(post, params)
    render(conn, "index.json", comments: comments, params: params)
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
    with {1, nil} <- Social.delete_comment(post, comment) do
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
      tags: ["comments"],
      summary: "List all comments on a given post",
      description: "List all comments created by any user on a given post",
      operationId: "listComments",
      parameters: [
        Operation.parameter(:post_id, :path, :integer, "The post id"),
        Operation.parameter(:size, :query, :integer, "The number of comments to retrieve"),
        Operation.parameter(
          :before,
          :query,
          :integer,
          "The cursor used to retrieve comments that come before the given comment id"
        ),
        Operation.parameter(
          :after,
          :query,
          :integer,
          "The cursor used to retrieve comments that come after the given comment id"
        )
      ],
      responses:
        %{
          200 => %Response{
            description: "CommentsList",
            content: %{
              "application/json" => %MediaType{
                schema: %Schema{
                  title: "CommentsList",
                  description: "List of all the comments on some post",
                  type: :object,
                  properties: %{
                    links: %Schema{
                      title: "CommentsPaginationLinks",
                      description: "Pagination links for comments",
                      type: :object,
                      properties: %{
                        prev: %Schema{type: :string},
                        next: %Schema{type: :string}
                      },
                      example: %{
                        next: "/api/posts/2/comments?after=5",
                        prev: "/api/posts/2/comments?before=8"
                      }
                    },
                    data: %Schema{
                      title: "CommentsList",
                      description: "List of comments on some post",
                      type: :array,
                      items: %Reference{"$ref": "#/components/schemas/Comment"}
                    }
                  }
                }
              }
            },
            links: %{
              prev: %Link{
                description: "Link to the previous page of posts",
                operationId: "listPosts",
                parameters: %{
                  size: "The size of the page",
                  before: "The cursor for the previous page"
                }
              },
              next: %Link{
                description: "Link to the next page of posts",
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

  # operation :show,
  #   summary: "Show a comment",
  #   description: "Show a comment by post id and comment id",
  #   parameters: [
  #     post_id: [
  #       in: :path,
  #       type: %Schema{type: :integer, minimum: 1},
  #       description: "The post id",
  #       example: 3245,
  #       required: true
  #     ],
  #     comment_id: [
  #       in: :path,
  #       type: %Schema{type: :integer, minimum: 1},
  #       description: "The comment id",
  #       example: 64,
  #       required: true
  #     ]
  #   ],
  #   responses: [
  #     ok: {"Comment", "application/json", Schemas.CommentResponse}
  #   ]

  @spec show_operation() :: Operation.t()
  def show_operation do
    %Operation{
      tags: ["comments"],
      summary: "Show a comment",
      description: "Show a comment by post id and comment id",
      parameters: [
        Operation.parameter(:post_id, :path, :integer, "The post id"),
        Operation.parameter(:comment_id, :path, :integer, "The comment id")
      ],
      responses:
        %{
          200 =>
            Operation.response("CommentResponse", "application/json", PostsWeb.Schemas.Comment)
        }
        |> ApiSpec.common_read_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["comments"],
      summary: "Create a comment on a post",
      description: "Create a comment on the post with the given id",
      requestBody: %RequestBody{
        content: %{"application/json" => %MediaType{schema: PostsWeb.Schemas.Comment}},
        description: "Comment Object input data",
        required: true
      },
      responses:
        %{
          201 =>
            Operation.response("CommentResponse", "application/json", PostsWeb.Schemas.Comment)
        }
        |> ApiSpec.common_write_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec put_operation() :: Operation.t()
  def put_operation do
    update_operation()
    |> Map.put(:operationId, "replaceComment")
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["comments"],
      summary: "Update an existing comment",
      description: "Update an existing comment by post id and comment id",
      operationId: "updateComment",
      parameters: [
        Operation.parameter(:post_id, :path, :integer, "The post id"),
        Operation.parameter(:comment_id, :path, :integer, "The comment id")
      ],
      requestBody: %RequestBody{
        content: %{"application/json" => %MediaType{schema: PostsWeb.Schemas.Comment}},
        description: "Comment Object input data",
        required: true
      },
      responses:
        %{
          201 =>
            Operation.response("CommentResponse", "application/json", PostsWeb.Schemas.Comment)
        }
        |> ApiSpec.common_write_responses()
        |> ApiSpec.response(404)
    }
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["comments"],
      summary: "Delete an existing comment",
      description: "Delete an existing post by post id and comment id",
      operationId: "deleteComment",
      parameters: [
        Operation.parameter(:post_id, :path, :integer, "The post id"),
        Operation.parameter(:comment_id, :path, :integer, "The comment id")
      ],
      responses:
        %{
          204 => Operation.response("CommentResponse", "application/json", nil)
        }
        |> ApiSpec.common_read_responses()
        |> ApiSpec.response(404)
    }
  end
end
