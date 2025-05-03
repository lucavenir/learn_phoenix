defmodule HeadsUp.Incidents do
  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident

  import Ecto.Query

  def filter_incidents() do
    query =
      from i in Incident,
        where: i.status == :resolved,
        where: ilike(i.name, "%in%")

    Repo.all(query)
  end

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def urgent_incidents(%Incident{} = incident) do
    Incident
    |> where([i], i.id != ^incident.id)
    |> order_by([i], desc: i.priority)
    |> limit(3)
    |> Repo.all()
  end
end
