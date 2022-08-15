defmodule RandomV.YoutubeApi do
  @api_url "https://youtube.googleapis.com/youtube/v3"

  def get_playlist(playlist_id, api_key) do
    HTTPoison.get!(
      "#{@api_url}/playlists?part=contentDetails&id=#{playlist_id}&maxResults=1&key=#{api_key}"
    ).body
    |> Poison.decode!()
  end

  def list_playlist_items(playlist_id, api_key, page_size \\ 5, page_token \\ "") do
    HTTPoison.get!(
      "#{@api_url}/playlistItems?part=contentDetails#{if page_token == "", do: "", else: "&pageToken=#{page_token}"}&maxResults=#{page_size}&playlistId=#{playlist_id}&key=#{api_key}"
    ).body
    |> Poison.decode!()
  end
end
