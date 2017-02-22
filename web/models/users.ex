defmodule WpApiWrapper.User do
  use WpApiWrapper.Web, :model

  #@primary_key {:ID, :id, autogenerate: true}

  schema "mining_users" do
    field :user_email, :string
    field :display_name, :string
    has_many :mining_posts, WpApiWrapper.Post
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_email, :display_name])
    |> validate_required([:user_email, :display_name])
  end
end
