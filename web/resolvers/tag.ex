defmodule WpApiWrapper.Resolver.Tag do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.TermTaxonomy
  alias WpApiWrapper.Post
  alias WpApiWrapper.Term

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      from u in TermTaxonomy,
      join: t in Term, on: t.term_id == u.term_taxonomy_id,
      where: u.taxonomy == "post_tag",
      select: %{id: u.term_taxonomy_id, tag_name: t.name, slug: t.slug}

    case Repo.get(query, id) do
      nil -> {:error, "Tag id #{id} not found"}
      tag -> {:ok, tag}
    end
  end

  def all(_, post_ids) do
    query =
       from p in Post,
       join: u in assoc(p, :termtaxonomy),
       join: t in Term, on: t.term_id == u.term_taxonomy_id,
       where: u.taxonomy == "post_tag" and p.id in ^post_ids,
       select: %{id: u.term_taxonomy_id, tag_name: t.name, slug: t.slug}
    Repo.all(query)
  end
end
