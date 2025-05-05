defmodule HeadsUp.Admin do
  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident

  require Incident

  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_statuses() do
    Ecto.Enum.values(Incident, :status)
  end

  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    incident
    |> Incident.changeset(attrs)
  end
end
