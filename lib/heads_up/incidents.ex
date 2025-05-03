defmodule HeadsUp.Incidents do
  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident

  require Incident

  import Ecto.Query

  def filter_incidents(params) do
    params = Map.reject(params, fn {_, v} -> v == "" end)

    Incident
    |> search_by(params["q"])
    |> with_status(params["status"])
    |> sort(params["sort_by"])
    |> Repo.all()
  end

  defp search_by(query, nil), do: query
  defp search_by(query, q), do: where(query, [i], ilike(i.name, ^"%#{q}%"))

  defp with_status(q, s) when Incident.is_status(s), do: where(q, status: ^s)
  defp with_status(query, _), do: query

  defp sort(query, s), do: order_by(query, ^sort_by(s))
  defp sort_by("name"), do: :name
  defp sort_by("priority_desc"), do: [desc: :priority]
  defp sort_by("priority_asc"), do: [asc: :priority]
  defp sort_by(_), do: :id

  def list_incidents, do: Repo.all(Incident)

  def get_incident!(id), do: Repo.get!(Incident, id)

  def urgent_incidents(%Incident{} = incident) do
    Incident
    |> where([i], i.id != ^incident.id)
    |> order_by([i], desc: i.priority)
    |> limit(3)
    |> Repo.all()
  end

  def list_all_statuses() do
    Ecto.Enum.values(Incident, :status)
  end
end
