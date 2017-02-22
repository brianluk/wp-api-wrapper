defmodule WpApiWrapper.Resolver.Index do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  def all( _args, _info) do
    query =
      from p in Post,
      where: p.post_status == "publish" and p.post_parent == 0,
      order_by: [desc: :post_date],
      limit: 10, offset: 10
    {:ok, Repo.all(query)}
  end

  def find(%{some_value: sv}, _info) do
    query =
      from p in Post,
      where: p.id == 876535
    rvalue = Repo.one(query).post_title
    {:ok, %{id: "1", data: sv, from_db: rvalue}}
  end
end
