defmodule Posts.Social.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :author, :integer
    field :body, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :author])
    |> validate_required([:title, :body, :author])
  end
end
