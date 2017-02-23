defmodule WpApiWrapper.Resolver.Filter do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.TermTaxonomy

  def find(%{id: id}, _info) do
    case Repo.get(TermTaxonomy, id) do
      user -> {:ok, user}
    end
  end
end
