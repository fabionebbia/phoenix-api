defmodule PostsWeb.Schemas.Comment do
  alias OpenApiSpex.Schema

  @behaviour OpenApiSpex.Schema

  @derive [Jason.Encoder]
  @schema %Schema{
    title: "Comment",
    description: "A comment created by a user on some post",
    type: :object,
    properties: %{
      id: %Schema{type: :integer, description: "The comment id"},
      post_id: %Schema{type: :integer, description: "The post id"},
      body: %Schema{type: :string, description: "The comment body"},
      author: %Schema{type: :integer, description: "The id of the comment author"}
    },
    required: [:id, :title, :body, :author],
    "x-struct": __MODULE__
  }

  def schema, do: @schema
  defstruct Map.keys(@schema.properties)
end
