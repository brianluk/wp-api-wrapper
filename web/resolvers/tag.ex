defmodule WpApiWrapper.Resolver.Tag do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.TermTaxonomy
  alias WpApiWrapper.Term

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from t in TermTaxonomy,
      join: p in Term, on: p.term_id == t.id,
      select: %{id: t.id, tag_name: p.name, slug: p.slug}

    case Repo.get(query, id) do
      nil -> {:error, "Tag id #{id} not found"}
      tag -> {:ok, tag}
    end
  end
end
