defmodule WpApiWrapper.Resolver.User do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.User

  def find(%{id: id}, _info) do
    case Repo.get(User, id) do
      user -> {:ok, user}
    end
  end
end
