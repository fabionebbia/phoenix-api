defmodule Posts.Repo.Migrations.CommentBelongsToPost do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
    end
  end
end
