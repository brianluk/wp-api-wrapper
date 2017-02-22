defmodule WpApiWrapper.PostMeta do
  use WpApiWrapper.Web, :model

  @primary_key {:meta_id, :id, autogenerate: true}

  schema "mining_postmeta" do
    field :meta_key, :string
    field :meta_value, :string

    belongs_to :mining_posts, WpApiWrapper.Post, foreign_key: :post_id
  end
end
