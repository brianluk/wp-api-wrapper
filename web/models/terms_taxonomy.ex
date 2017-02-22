defmodule WpApiWrapper.TermTaxonomy do
  use WpApiWrapper.Web, :model

  @primary_key {:term_taxonomy_id, :id, autogenerate: true}

  schema "mining_term_taxonomy" do
    field :taxonomy, :string
    field :parent, :integer
    field :count, :integer

    belongs_to :terms, WpApiWrapper.Term, foreign_key: :term_id, references: :term_id
    many_to_many :posts, WpApiWrapper.Post, join_through: "mining_term_relationships", join_keys: [term_taxonomy_id: :term_taxonomy_id, object_id: :ID]
  end

end
