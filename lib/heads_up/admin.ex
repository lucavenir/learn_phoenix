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
end
