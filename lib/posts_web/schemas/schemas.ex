defmodule PostsWeb.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Links do
    OpenApiSpex.schema(%{
      type: :object,
      description: "Links for pagination",
      properties: %{
        prev: %Schema{type: :string, description: "The previous page"},
        next: %Schema{type: :string, description: "The next page"}
      },
      required: [:prev, :next]
    })
  end

  # defmodule Post do
  #   OpenApiSpex.schema(%{
  #     title: "Post",
  #     description: "A post created by some user",
  #     type: :object,
  #     properties: %{
  #       id: %Schema{type: :integer, description: "The post id"},
  #       title: %Schema{type: :string, description: "The post title"},
  #       body: %Schema{type: :string, description: "The post body"},
  #       author: %Schema{type: :integer, description: "The id of the post author"}
  #     },
  #     required: [:title, :body, :author],
  #     example: %{
  #       "id" => 1,
  #       "author" => 236_578,
  #       "title" => "My post title",
  #       "body" => "My post body"
  #     }
  #   })
  # end

  # defmodule PostRequest do
  #   OpenApiSpex.schema(%{
  #     title: "PostRequest",
  #     description: "POST body for creating a post",
  #     type: :object,
  #     properties: %{
  #       post: %Schema{anyOf: [Post]}
  #     },
  #     required: [:post],
  #     example: %{
  #       "post" => %{
  #         "author" => 234_853,
  #         "title" => "Post title",
  #         "body" => "Post body"
  #       }
  #     }
  #   })
  # end

  # defmodule PostResponse do
  #   OpenApiSpex.schema(%{
  #     title: "PostResponse",
  #     description: "Response schema for single post",
  #     type: :object,
  #     properties: %{
  #       data: Post
  #     },
  #     example: %{
  #       "data" => %{
  #         "id" => 1,
  #         "author" => 236_578,
  #         "title" => "My post title",
  #         "body" => "My post body"
  #       }
  #     }
  #   })
  # end

  # defmodule PostsResponse do
  #   OpenApiSpex.schema(%{
  #     title: "PostsResponse",
  #     description: "Response schema for multiple posts",
  #     type: :object,
  #     properties: %{
  #       data: %Schema{description: "The posts details", type: :array, items: Post},
  #       links: %Schema{
  #         description: "The previous and next page links",
  #         type: :object,
  #         allOf: [Links]
  #       }
  #     },
  #     links: %{
  #       we: %OpenApiSpex.Link{description: "we"}
  #     },
  #     example: %{
  #       "data" => [
  #         %{
  #           "id" => 1,
  #           "author" => 236_578,
  #           "title" => "My post title",
  #           "body" => "My post body"
  #         },
  #         %{
  #           "id" => 2,
  #           "author" => 548_484,
  #           "title" => "Another post title",
  #           "body" => "Yet another post body"
  #         }
  #       ]
  #     }
  #   })
  # end

  defmodule Comment do
    OpenApiSpex.schema(%{
      title: "Comment",
      description: "A comment on some post",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "The comment id"},
        post_id: %Schema{type: :integer, description: "The post id"},
        body: %Schema{type: :string, description: "The comment body"},
        author: %Schema{type: :integer, description: "The id of the comment author"}
      },
      required: [:post_id, :body, :author],
      example: %{
        "id" => 1,
        "post_id" => 2345,
        "author" => 236_578,
        "body" => "My comment body"
      }
    })
  end

  defmodule CommentRequest do
    OpenApiSpex.schema(%{
      title: "CommentRequest",
      description: "POST body for creating a comment",
      type: :object,
      properties: %{
        comment: %Schema{anyOf: [Comment]}
      },
      required: [:comment],
      example: %{
        "comment" => %{
          "author" => 234_853,
          "body" => "Comment body"
        }
      }
    })
  end

  defmodule CommentResponse do
    OpenApiSpex.schema(%{
      title: "CommentResponse",
      description: "Response schema for single comment",
      type: :object,
      properties: %{
        data: Comment
      },
      example: %{
        "data" => %{
          "id" => 1,
          "post_id" => 2345,
          "author" => 236_578,
          "body" => "My comment body"
        }
      }
    })
  end

  defmodule CommentsResponse do
    OpenApiSpex.schema(%{
      title: "CommentsResponse",
      description: "Response schema for multiple comments",
      type: :object,
      properties: %{
        data: %Schema{description: "The comments details", type: :array, items: Comment},
        links: %Schema{
          description: "The previous and next page links",
          type: :object,
          allOf: [Links]
        }
      },
      example: %{
        "data" => [
          %{
            "id" => 1,
            "post_id" => 2345,
            "author" => 236_578,
            "body" => "My comment body"
          },
          %{
            "id" => 2,
            "post_id" => 2345,
            "author" => 854_567,
            "body" => "Another comment body"
          }
        ]
      }
    })
  end
end
