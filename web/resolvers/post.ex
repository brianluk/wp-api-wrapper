defmodule WpApiWrapper.Resolver.Post do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  def find(%{id: id}, _info) do
    case Repo.get(Post, id) do
      nil -> {:error, "Post id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, _args, _info) do
    query =
      from p in Post,
      where: p.post_status == "publish" and p.post_parent == 0,
      order_by: [desc: :post_date],
      limit: 10
    {:ok, Repo.all(query)}
  end
end
