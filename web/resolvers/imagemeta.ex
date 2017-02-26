defmodule WpApiWrapper.Resolver.ImageMeta do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.PostMeta

  def find(%{id: id}, _info) do
    case Repo.get(PostMeta, id) do
      user -> {:ok, user}
    end
  end
end
