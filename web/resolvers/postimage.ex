defmodule WpApiWrapper.Resolver.PostImage do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.PostImage

  def find(%{id: id}, _info) do
    case Repo.get(PostImage, id) do
      user -> {:ok, user}
    end
  end
end
