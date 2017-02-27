defmodule WpApiWrapper.Resolver.Revision do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from r in Post,
      where: r.post_type == "revision"
    case Repo.get(query, id) do
      nil -> {:error, "Revision id #{id} not found"}
      revision -> {:ok, revision}
    end
  end

  def all(_, post_ids) do
    query =
      from p in Post,
      where: p.post_type == "revision" and p.post_parent in ^post_ids,
      order_by: [desc: :post_date]
    Repo.all(query)
  end
end
