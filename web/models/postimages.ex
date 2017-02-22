defmodule WpApiWrapper.PostImage do
  use WpApiWrapper.Web, :model


  #@primary_key {:ID, :id, autogenerate: true}

  schema "mining_posts" do
    field :post_title, :string
    field :post_status, :string
    field :post_type, :string
    field :post_mime_type, :string
    field :guid, :string
    belongs_to :post, WpApiWrapper.Post, foreign_key: :post_parent
    has_many :postmeta, WpApiWrapper.PostMeta, foreign_key: :post_id
  end

end
