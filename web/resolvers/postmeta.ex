defmodule WpApiWrapper.Resolver.PostMeta do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.PostMeta

  import Ecto.Query

  #defstruct [:bitly, :secondary_title]

  def find(%{id: id}, _info) do
    query =
      PostMeta
      |> where(post_id: ^id)
    results = Repo.all(query)
    #result_map =
    Enum.map(results, fn(x) ->
        case x.meta_key do
          "_wpbitly" -> %{bitly: x.meta_value}
          "_secondary_title" -> %{secondary_title: x.meta_value}
          _ -> nil
        end
      end)
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.reduce(%{}, fn (map, acc) -> Map.merge(acc, map) end)

    #struct(WpApiWrapper.Resolver.Postmeta, result_map)
  end


end
