defmodule RandomV.LinkController do
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/music" do
    [playlist_id: playlist_id, youtube_api_key: api_key] =
      Application.get_all_env(:youtube_random_v)

    {time, link} = :timer.tc(&RandomV.LinkService.get_random_link/2, [playlist_id, api_key])
    Logger.info("got a link in #{time / 1000} ms: #{link}")

    params = fetch_query_params(conn).query_params

    case Map.has_key?(params, "redirect") do
      true -> redirect(conn, link)
      _ -> send_link_json(conn, link)
    end
  end

  def send_link_json(conn, link) do
    send_resp(conn, 200, Poison.encode!(%{link: link}))
  end

  def redirect(conn, link) do
    conn
    |> put_resp_header("location", link)
    |> send_resp(302, "text/html")
  end

  get "/health" do
    send_resp(conn, 200, "ok\n")
  end

  get _ do
    send_resp(conn, 404, "not found")
  end
end
