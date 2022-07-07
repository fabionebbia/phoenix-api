defmodule Posts.SocialTest do
  use Posts.DataCase

  alias Posts.Social

  describe "posts" do
    alias Posts.Social.Post

    import Posts.SocialFixtures

    @invalid_attrs %{author: nil, body: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Social.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Social.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{author: 42, body: "some body", title: "some title"}

      assert {:ok, %Post{} = post} = Social.create_post(valid_attrs)
      assert post.author == 42
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{author: 43, body: "some updated body", title: "some updated title"}

      assert {:ok, %Post{} = post} = Social.update_post(post, update_attrs)
      assert post.author == 43
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_post(post, @invalid_attrs)
      assert post == Social.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Social.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Social.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Social.change_post(post)
    end
  end

  describe "comments" do
    alias Posts.Social.Comment

    import Posts.SocialFixtures

    @invalid_attrs %{author: nil, body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Social.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Social.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{author: 42, body: "some body"}

      assert {:ok, %Comment{} = comment} = Social.create_comment(valid_attrs)
      assert comment.author == 42
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{author: 43, body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Social.update_comment(comment, update_attrs)
      assert comment.author == 43
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_comment(comment, @invalid_attrs)
      assert comment == Social.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Social.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Social.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Social.change_comment(comment)
    end
  end
end
