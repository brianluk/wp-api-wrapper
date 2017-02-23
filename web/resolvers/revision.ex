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
end
