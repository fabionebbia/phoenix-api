defmodule Posts.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset
  require OpenApiSpex

  schema "posts" do
    field :author, :integer
    field :body, :string
    field :title, :string
    has_many :comments, Posts.Social.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :author])
    |> validate_required([:title, :body, :author])
  end
end
