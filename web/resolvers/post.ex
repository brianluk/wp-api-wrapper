defmodule WpApiWrapper.Resolver.Post do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from p in Post,
      where: p.post_status == "publish" and p.post_parent == 0
    case Repo.get(query, id) do
      nil -> {:error, "Post id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, _args, _info) do
    query =
      from p in Post,
      where: p.post_status == "publish" and p.post_parent == 0,
      order_by: [desc: :post_date]
    {:ok, Repo.all(query)}
  end

  def by_name(%{post_name: name}, _) do
    query =
      Post
      |> where(post_status: "publish")
      |> where(post_name: ^name)
      |> where(post_parent: 0)
    {:ok, Repo.one(query)}
  end
end
