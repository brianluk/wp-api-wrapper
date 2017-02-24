defmodule WpApiWrapper.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation
  use Absinthe.Ecto, repo: WpApiWrapper.Repo
  alias WpApiWrapper.Resolver
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post

  import Ecto.Query

  node object :index, description: "Paginated Latest Posts" do
    connection field :latest_posts, node_type: :post do
      resolve fn
        pagination_args, %{source: _} ->
          query =
            from p in Post,
            where: p.post_status == "publish" and p.post_parent == 0,
            order_by: [desc: :post_date]
          {:ok, Absinthe.Relay.Connection.from_query(
            query,&Repo.all/1, pagination_args
          )}
      end
    end
  end

  node object :user, description: "Name of Post Author" do
    field :display_name, non_null(:string)
    field :user_email, :string
  end

  node object :post, description: "Post Article" do
    field :post_date, non_null(:string)
    field :post_content, non_null(:string)
    field :post_title, non_null(:string)
    field :post_status, non_null(:string)
    field :post_type, non_null(:string)
    field :post_author, :user, resolve: assoc(:users)
    field :tags, list_of(:tag) do
      resolve fn post, _, _ ->
        batch({Resolver.Tag, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.id == post.id))}
        end)
      end
    end
    field :categories, list_of(:category) do
      resolve fn post, _, _ ->
        batch({Resolver.Category, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.id == post.id))}
        end)
      end
    end
    #field :categories, list_of(:category), resolve: assoc(:category)
    #field :filters, list_of(:filter), resolve: assoc(:filter)
    #field :metas, list_of(:meta), resolve: assoc(:meta)
    #field :images, list_of(:postimage), resolve: assoc(:postimage)
  end

  node object :tag, description: "Term Name" do
    field :tag_name, non_null(:string)
    field :slug, non_null(:string)
  end

  node object :filter, description: "Term Name" do
    field :filter_name, non_null(:string)
    field :slug, non_null(:string)
  end

  node object :category, description: "Term Name" do
    field :category_name, non_null(:string)
    field :slug, non_null(:string)
  end

  node object :meta, description: "Meta Data for Posts and images" do
    field :meta_key, non_null(:string)
    field :meta_value, non_null(:string)
  end

  node object :postimage, description: "Images for a Post" do
    field :post_parent, :integer
    field :post_type, non_null(:string)
    field :post_mime_type, non_null(:string)
    field :guid, non_null(:string)
    field :metas, list_of(:meta), resolve: assoc(:meta)
  end

  node object :revision do
    field :post_parent, :integer
    field :post_type, :string
  end
  #scalar :time do
  #  decription "Time (in ISOz format)"
  #  parse &Timex.parse(&1.value)
  #  serialize &Timex.format!(&1, "{ISO:Extended:Z}")
  #end
end
