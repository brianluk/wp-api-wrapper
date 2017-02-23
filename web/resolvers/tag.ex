defmodule WpApiWrapper.Resolver.Tag do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.TermTaxonomy
  alias WpApiWrapper.Term

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from t in TermTaxonomy,
      where:
    case Repo.get(TermTaxonomy, id) do
      tag -> {:ok, tag}
    end
  end
end
