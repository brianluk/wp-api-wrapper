defmodule WpApiWrapper.Resolver.PostMeta do
  alias WpApiWrapper.Repo
  alias WpApiWrapper.PostMeta

  import Ecto.Query

  def find(%{id: id}, _info) do
    query =
      PostMeta
      |> where(post_id: ^id)
    results = Repo.all(query)

    Enum.map(results, fn(x) ->
        case x.meta_key do
          "_wpbitly" -> %{bitly: x.meta_value}
          "_secondary_title" -> %{secondary_title: x.meta_value}
          _ -> nil
        end
      end)
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.reduce(%{}, fn (map, acc) -> Map.merge(acc, map) end)
  end

  def all(_, post_ids) do
    query =
      PostMeta
      |> where([p], p.post_id in ^post_ids)
    results = Repo.all(query)

    Enum.map(results, fn(result) ->
        case result.meta_key do
          "_wpbitly" -> %{bitly: result.meta_value, id: result.post_id}
          "_secondary_title" -> %{secondary_title: result.meta_value, id: result.post_id}
          _ -> nil
        end
      end)
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.group_by(fn x -> x.id end)
    |> Enum.map(fn({_k,v}) -> v end)
    |> Enum.map(fn x -> Enum.reduce(x, fn(map, acc) -> Map.merge(acc, map) end) end)
    
  end

end
