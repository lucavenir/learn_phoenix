defmodule Raffley.Raffles do
  alias Raffley.Repo
  alias Raffley.Raffles.Raffle

  import Ecto.Query

  def list_raffles() do
    Repo.all(Raffle)
  end

  def filter_raffles(params) do
    params = Map.reject(params, fn {_, v} -> v == "" end)

    Raffle
    |> with_status(params["status"])
    |> search_by(params["q"])
    |> sort(params["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(open closed upcoming),
    do: where(query, status: ^status)

  defp with_status(query, _), do: query

  defp search_by(query, nil), do: query
  defp search_by(query, q), do: where(query, [r], ilike(r.prize, ^"%#{q}%"))

  defp sort(query, s), do: order_by(query, ^sort_by(s))
  defp sort_by("prize"), do: :prize
  defp sort_by("ticket_price_desc"), do: [desc: :ticket_price]
  defp sort_by("ticket_price_asc"), do: [asc: :ticket_price]
  defp sort_by(_), do: :id

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def featured_raffles(%Raffle{} = raffle) do
    Raffle
    |> where([r], r.id != ^raffle.id)
  end

  def list_raffle_statuses() do
    Ecto.Enum.values(Raffle, :status)
  end
end
