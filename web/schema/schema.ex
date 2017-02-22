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
      %{meta_key: _,}, _ ->
        :meta
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
#      arg :id, non_null(:id)
      arg :some_value, :string
      resolve &Resolver.Index.find/2
    end
    node field do
      resolve fn
        %{type: :user, id: id}, _ ->
          {:ok, Resolver.User.find(%{id: id},%{})}
        %{type: :post, id: id}, _ ->
          {:ok, Resolver.Post.find(%{id: id},%{})}
        %{type: :index, id: id}, _ ->
          {:ok, Resolver.Index.find(%{id: id},%{})}
      end
    end
  end
end
