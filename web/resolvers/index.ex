defmodule WpApiWrapper.Resolver.Index do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  def all( _args, _info) do
    {:ok, %{}}
  end

  def find(%{id: id}, _info) do
    case Repo.get(Post, id) do
      nil -> {:error, "Post id #{id} not found"}
      user -> {:ok, user}
    end
  end
end
