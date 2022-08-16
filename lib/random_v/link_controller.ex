defmodule RandomV.LinkController do
  use Plug.Router
  require Logger
  alias RandomV.LinkService

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/api/v1/link" do
    api_key = Application.get_env(:youtube_random_v, :youtube_api_key)

    query = fetch_query_params(conn).query_params

    playlist_id =
      case Map.fetch(query, "playlist_id") do
        {:ok, p_id} -> p_id
        :error -> Application.get_env(:youtube_random_v, :playlist_id)
      end

    {time, link} = :timer.tc(&LinkService.get_random_link/2, [playlist_id, api_key])
    Logger.info("Got a link in #{time / 1000} ms: #{link}")

    case Map.has_key?(query, "redirect") do
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
