defmodule Posts.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :author, :integer
    field :body, :string
    belongs_to :post, Posts.Social.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :author, :post_id])
    |> validate_required([:body, :author, :post_id])
  end
end
