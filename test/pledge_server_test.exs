defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "gets the 3 most recent pledges and totals" do
    {:ok, pid} = PledgeServer.start_link([])

    PledgeServer.create_pledge("Pedro", 123)
    PledgeServer.create_pledge("Maria", 456)
    PledgeServer.create_pledge("Regina", 789)
    PledgeServer.create_pledge("Vitoria", 3)

    expected_total = [
      {"Vitoria", 3},
      {"Regina", 789},
      {"Maria", 456}
    ]

    assert PledgeServer.recent_pledges() == expected_total
    assert PledgeServer.total_pledged() == 1248

    Process.exit(pid, :normal)
  end
end
