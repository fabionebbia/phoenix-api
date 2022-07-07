defmodule Posts.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :author, :integer

      timestamps()
    end
  end
end
