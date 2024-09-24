defmodule Portfolio.Quizzer.OpenTDBTest do
  use ExUnit.Case, async: true

  alias Portfolio.Quizzer.OpenTDB
  alias Portfolio.Quizzer.OpenTDB.CategoriesAPI

  setup do
    bypass = Bypass.open()
    host_url = "http://localhost:#{bypass.port}/"

    {:ok, bypass: bypass, host_url: host_url}
  end

  test "get categories", %{bypass: bypass, host_url: host_url} do
    response = %{
      "trivia_categories" => [%{"id" => 1, "name" => "1"}, %{"id" => 2, "name" => "2"}]
    }

    categories = [CategoriesAPI.all_categories()] ++ ["1", "2"]

    retry_get_categories = 100
    delay = 10

    Bypass.expect(bypass, "GET", CategoriesAPI.path(), fn conn ->
      Plug.Conn.resp(conn, 200, Poison.encode!(response))
    end)

    {:ok, server} = OpenTDB.start_link(host_url: host_url, name: nil)

    assert {:ok, categories} == OpenTDB.get_categories(server: server)

    Bypass.down(bypass)

    {:ok, server} =
      OpenTDB.start_link(
        host_url: host_url,
        retry_get_categories: retry_get_categories,
        name: nil
      )

    assert {:error, :not_initialized} == OpenTDB.get_categories(server: server)

    Bypass.up(bypass)

    Process.sleep(retry_get_categories + delay)

    assert {:ok, categories} == OpenTDB.get_categories(server: server)
  end
end
