defmodule MailerServer do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    Phoenix.PubSub.subscribe(:mailer_pubsub, "request")
    {:ok, %{}}
  end

  @impl true
  def handle_info(%{offset: offset, limit: limit}, state) do
    result = send_mail(offset, limit)
    case result do
      :continue ->
        Phoenix.PubSub.broadcast(:mailer_pubsub, "request", %{offset: offset+limit, limit: limit})
        {:noreply, state}
      _ -> {:noreply, state}
    end
  end

  defp send_mail(offset, limit) do
    users = UserRepository.get_active_users(offset, limit)

    case users do
      [] -> :stop
      _ ->
        users |> Enum.map(fn [name] ->
          Logger.info("Sending email to " <> name)
          BEChallengex.send_email(%{name: name})
        end)
        :continue
    end
  end
end
