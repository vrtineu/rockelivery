defmodule Rockelivery.Orders.ReportRunner do
  use GenServer

  require Logger

  alias Rockelivery.Orders.Report

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(state) do
    Logger.info("Starting report runner...")
    schedule_report_generation()
    {:ok, state}
  end

  # Receives any type of messages
  @impl true
  def handle_info(:generate, state) do
    Logger.info("Generating report...")
    Report.create()
    schedule_report_generation()
    {:noreply, state}
  end

  def schedule_report_generation do
    Process.send_after(self(), :generate, 1000 * 30)
  end
end