defmodule WpApiWrapper.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation
  use Absinthe.Ecto, repo: WpApiWrapper.Repo
  alias WpApiWrapper.Resolver
  alias WpApiWrapper.Repo
  alias WpApiWrapper.Post
  alias WpApiWrapper.Term

  import Ecto.Query

  node object :index, description: "Paginated Latest Posts" do
    connection field :latest_posts, node_type: :post do
      resolve fn
        pagination_args, %{source: _} ->
          query =
            Post
            |> where(post_status: "publish")
            |> where(post_parent: 0)
            |> where([p], p.post_type != "sponsored_content")
            |> order_by([desc: :post_date])
          {:ok, Absinthe.Relay.Connection.from_query(
            query,&Repo.all/1, pagination_args
          )}
      end
    end
  end

  node object :user, description: "Name of Post Author" do
    field :display_name, non_null(:string)
    field :user_email, :string
    field :user_nicename, :string

    connection field :latest_posts, node_type: :post do
      resolve fn pagination_args, %{source: user} ->
        query =
          from p in Post,
          join: u in assoc(p, :users),
          where: u.user_nicename == ^user.user_nicename,
          where: p.post_status == "publish",
          where: p.post_type != "sponsored_content",
          where: p.post_parent == 0,
          order_by: [desc: :post_date]
        {:ok, Absinthe.Relay.Connection.from_query(
          query,&Repo.all/1, pagination_args
        )}
      end
    end

  end

  node object :post, description: "Post Article" do
    field :post_date, non_null(:string)
    field :post_content, non_null(:string)
    field :post_title, non_null(:string)
    field :post_status, non_null(:string)
    field :post_type, non_null(:string)
    field :post_excerpt, :string
    field :post_name, :string
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
    field :filters, list_of(:filter) do
      resolve fn post, _, _ ->
        batch({Resolver.Filter, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.id == post.id))}
        end)
      end
    end
    field :meta, list_of(:postmeta) do
      resolve fn post, _, _ ->
        #{:ok, Resolver.PostMeta.find(%{id: post.id},%{})}
        batch({Resolver.PostMeta, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.id == post.id))}
        end)
      end
    end

    field :images, :postimage do
      resolve fn post, _, _ ->
        batch({Resolver.PostImage, :all}, post.id, fn batch_results ->
          {:ok, List.first(Enum.filter(batch_results, &(&1.post_parent == post.id)))}
        end)
      end
    end

    field :revisions, list_of(:revision) do
      resolve fn post, _, _ ->
        batch({Resolver.Revision, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.post_parent == post.id))}
        end)
      end
    end
  end

  node object :tag, description: "Term Name" do
    field :tag_name, non_null(:string)
    field :slug, non_null(:string)

    connection field :latest_posts, node_type: :post do
      resolve fn pagination_args, %{source: tag} ->
        query =
          from p in Post,
          join: u in assoc(p, :termtaxonomy),
          join: t in Term, on: t.term_id == u.term_taxonomy_id,
          where: u.taxonomy == "post_tag" and t.slug == ^tag.slug,
          order_by: [desc: :post_date]
        {:ok, Absinthe.Relay.Connection.from_query(
          query,&Repo.all/1, pagination_args
        )}
      end
    end
  end

  node object :filter, description: "Term Name" do
    field :filter_name, non_null(:string)
    field :slug, non_null(:string)
  end

  node object :category, description: "Term Name" do
    field :category_name, non_null(:string)
    field :slug, non_null(:string)
  end

  node object :postmeta, description: "Meta Data for Posts" do
    field :bitly, :string
    field :secondary_title, :string
  end

  node object :imagemeta, description: "Meta Data for Images" do
    field :file, non_null(:string)
    field :metadata, non_null(:string)
    field :alt_tag, :string
  end

  node object :postimage, description: "Images for a Post" do
    field :post_parent, :integer
    field :post_type, non_null(:string)
    field :post_mime_type, non_null(:string)
    field :guid, non_null(:string)
    field :imagemetas, list_of(:imagemeta) do
      resolve fn post, _, _ ->
        #{:ok, Resolver.PostMeta.find(%{id: post.id},%{})}
        batch({Resolver.ImageMeta, :all}, post.id, fn batch_results ->
          {:ok, Enum.filter(batch_results, &(&1.id == post.id))}
        end)
      end
    end
  end

  node object :revision do
    field :post_parent, :integer
    field :post_date, :string
    field :post_content, :string
    field :post_title, :string
    field :post_author, :user, resolve: assoc(:users)
    field :post_excerpt, :string
  end
  #scalar :time do
  #  decription "Time (in ISOz format)"
  #  parse &Timex.parse(&1.value)
  #  serialize &Timex.format!(&1, "{ISO:Extended:Z}")
  #end
end
