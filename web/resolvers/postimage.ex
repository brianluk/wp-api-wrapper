defmodule WpApiWrapper.Resolver.PostImage do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.PostImage

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from i in PostImage,
      where: i.post_type == "attachment"
    case Repo.get(query, id) do
      nil -> {:error, "Image id #{id} not found"}
      image -> {:ok, image}
    end
  end
end
