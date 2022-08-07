defmodule AnalyticsWeb.EventController do
  use AnalyticsWeb, :controller

  alias Analytics.Metric

  @backend Application.get_env(:analytics, :backend)

  def create(conn, params) do
    metric = %Metric{
      project: conn.assigns.project,
      account_id: params["account_id"],
      event: params["event"],
      tags: params["tags"]
    }

    spawn(fn ->
      @backend.record(metric)
    end)

    conn
    |> put_status(:created)
    |> json(%{})
  end
end
