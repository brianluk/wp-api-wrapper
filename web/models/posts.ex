defmodule WpApiWrapper.Post do
  use WpApiWrapper.Web, :model


  #@primary_key {:ID, :id, autogenerate: true}

  schema "mining_posts" do
    field :post_date, Ecto.DateTime
    field :post_content, :string
    field :post_title, :string
    field :post_status, :string
    field :post_parent, :integer
    field :post_type, :string
    field :post_excerpt, :string
    field :post_name, :string

    belongs_to :users, WpApiWrapper.User, foreign_key: :post_author
    many_to_many :termtaxonomy, WpApiWrapper.TermTaxonomy, join_through: "mining_term_relationships", join_keys: [object_id: :id, term_taxonomy_id: :term_taxonomy_id]
  end

end
