defmodule WpApiWrapper.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema

  alias WpApiWrapper.Resolver

  import_types WpApiWrapper.Schema.Types

  node interface do
    resolve_type fn
      %{display_name: _}, _ ->
        :user
      %{post_title: _}, _ ->
        :post
      %{tag_name: _}, _ ->
        :tag
      %{filter_name: _}, _ ->
        :filter
      %{category_name: _}, _ ->
        :category
      %{bitly: _,}, _ ->
        :postmeta
      %{file: _,}, _ ->
        :imagemeta
      %{post_mime_type: _}, _ ->
        :postimage
      %{post_parent: _}, _ ->
        :revision
      %{viewer: _}, _ ->
        :viewer
      %{index: _}, _ ->
        :index
      _, _ ->
        nil
    end
  end

  connection node_type: :post
  connection node_type: :user

  query do
    field :index, :index do
      resolve &Resolver.Index.all/2
    end
    field :post, :post do
      arg :id, :id
      resolve &Resolver.Post.find/2
    end
    field :tag, :tag do
      arg :id, :id
      resolve &Resolver.Tag.find/2
    end
    node field do
      resolve fn
        %{type: :user, id: id}, _ ->
          {:ok, Resolver.User.find(%{id: id},%{})}
        %{type: :post, id: id}, _ ->
          {:ok, Resolver.Post.find(%{id: id},%{})}
        %{type: :tag, id: id}, _ ->
          {:ok, Resolver.Tag.find(%{id: id},%{})}
        %{type: :filter, id: id}, _ ->
          {:ok, Resolver.Filter.find(%{id: id},%{})}
        %{type: :category, id: id}, _ ->
          {:ok, Resolver.Category.find(%{id: id},%{})}
        %{type: :postmeta, id: id}, _ ->
          {:ok, Resolver.PostMeta.find(%{id: id},%{})}
        %{type: :imagemeta, id: id}, _ ->
          {:ok, Resolver.ImageMeta.find(%{id: id},%{})}
        %{type: :postimage, id: id}, _ ->
          {:ok, Resolver.PostImage.find(%{id: id},%{})}
        %{type: :revision, id: id}, _ ->
          {:ok, Resolver.Revision.find(%{id: id},%{})}
        %{type: :index, id: id}, _ ->
          {:ok, Resolver.Index.find(%{id: id},%{})}
      end
    end
  end
end
