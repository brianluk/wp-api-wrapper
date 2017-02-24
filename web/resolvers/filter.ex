defmodule WpApiWrapper.Resolver.Filter do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.TermTaxonomy
  alias WpApiWrapper.Term

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from u in TermTaxonomy,
      join: t in Term, on: t.term_id == u.term_taxonomy_id,
      where: u.taxonomy == "post-filters",
      select: %{id: u.term_taxonomy_id, category_name: t.name, slug: t.slug}

    case Repo.get(query, id) do
      nil -> {:error, "Filter id #{id} not found"}
      tag -> {:ok, tag}
    end
  end

  def all(_, post_ids) do
    query =
       from u in TermTaxonomy,
       join: p in assoc(u, :posts),
       join: t in Term, on: t.term_id == u.term_id,
       where: u.taxonomy == "post-filters" and p.id in ^post_ids,
       select: %{id: p.id, category_name: t.name, slug: t.slug}
    Repo.all(query)
  end
end
