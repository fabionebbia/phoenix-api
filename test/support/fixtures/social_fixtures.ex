defmodule Posts.SocialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Posts.Social` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        author: 42,
        body: "some body",
        title: "some title"
      })
      |> Posts.Social.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        author: 42,
        body: "some body"
      })
      |> Posts.Social.create_comment()

    comment
  end
end
