defmodule PostsWeb.CommentController do
  use PostsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Posts.Social
  alias Posts.Social.Comment
  alias OpenApiSpex.Schema
  alias PostsWeb.Schemas

  action_fallback PostsWeb.FallbackController

  tags ["comments"]

  operation :index,
    summary: "Lists comments",
    description: "Lists all comments on a post by id",
    parameters: [
      post_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ],
      size: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The maximum number of comments to include per page",
        example: 10,
        required: false
      ],
      before: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The cursor used to retrieve comments that come before the given comment id",
        example: 3451,
        required: false
      ],
      after: [
        in: :query,
        type: %Schema{type: :integer, minimum: 0},
        description: "The cursor used to retrieve comments that come after the given comment id",
        example: 3451,
        required: false
      ]
    ],
    responses: [
      # ok: {"Comment List Response", "application/json", Schemas.CommentsResponse},
      ok: %OpenApiSpex.Response{
        description: "Comment List Response",
        content: %{

        }
        # links:
      }
    ]

  def index(conn, %{"post_id" => post} = params) do
    comments = Social.list_comments(post, params)
    render(conn, "index.json", comments: comments, params: params)
  end

  operation :create,
    summary: "Create a comment",
    description: "Create a new comment on a post",
    request_body:
      {"The comment attributes", "application/json", Schemas.CommentRequest, required: true},
    responses: [
      created: {"Comment", "application/json", Schemas.CommentResponse}
    ]

  def create(conn, %{"post_id" => post, "comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Social.create_comment(post, comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_comment_path(conn, :show, post, comment))
      |> render("show.json", comment: comment)
    end
  end

  operation :show,
    summary: "Show comment",
    description: "Show a comment by post id and comment id",
    parameters: [
      post_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ],
      comment_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The comment id",
        example: 64,
        required: true
      ]
    ],
    responses: [
      ok: {"Comment", "application/json", Schemas.CommentResponse}
    ]

  def show(conn, %{"post_id" => post, "comment_id" => id}) do
    comment = Social.get_comment!(post, id)
    render(conn, "show.json", comment: comment)
  end

  operation :update,
    summary: "Update comment",
    description: "Update a comment by post id and comment id",
    parameters: [
      post_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ],
      comment_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The comment id",
        example: 64,
        required: true
      ]
    ],
    request_body:
      {"The post attributes", "application/json", Schemas.PostRequest, required: true},
    responses: [
      ok: {"Post", "application/json", Schemas.PostResponse}
    ]

  def update(conn, %{"post_id" => post, "comment_id" => comment_id, "comment" => comment_params}) do
    comment = Social.get_comment!(post, comment_id)

    with {:ok, %Comment{} = comment} <- Social.update_comment(post, comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  operation :delete,
    summary: "Delete comment",
    description: "Delete a comment by post id and comment id",
    parameters: [
      post_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The post id",
        example: 3245,
        required: true
      ],
      comment_id: [
        in: :path,
        type: %Schema{type: :integer, minimum: 1},
        description: "The comment id",
        example: 64,
        required: true
      ]
    ],
    # TODO
    responses: []

  def delete(conn, %{"post_id" => post, "comment_id" => comment}) do
    with {1, nil} <- Social.delete_comment(post, comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
