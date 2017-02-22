defmodule WpApiWrapper.Router do
  use WpApiWrapper.Web, :router

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :graphql

    forward "/graphql", Absinthe.Plug, schema: WpApiWrapper.Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WpApiWrapper.Schema
    end
  end
end
