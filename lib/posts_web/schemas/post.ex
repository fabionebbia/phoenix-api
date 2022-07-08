defmodule PostsWeb.Schemas.Post do
  alias OpenApiSpex.Schema

  @behaviour OpenApiSpex.Schema

  @derive [Jason.Encoder]
  @schema %Schema{
    title: "Post",
    description: "A post created by a user",
    type: :object,
    properties: %{
      id: %Schema{type: :integer, description: "The post id"},
      title: %Schema{type: :string, description: "The post title"},
      body: %Schema{type: :string, description: "The post body"},
      author: %Schema{type: :integer, description: "The id of the post author"}
    },
    required: [:id, :title, :body, :author],
    "x-struct": __MODULE__
  }

  def schema, do: @schema
  defstruct Map.keys(@schema.properties)
end
