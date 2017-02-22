defmodule WpApiWrapper.Term do
  use WpApiWrapper.Web, :model

  @primary_key {:term_id, :id, autogenerate: true}

  schema "mining_terms" do
    field :name, :string
    field :slug, :string
    field :term_group, :integer

    has_many :mining_term_taxonomy, WpApiWrapper.TermTaxonomy
  end

end
