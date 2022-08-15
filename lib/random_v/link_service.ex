defmodule RandomV.LinkService do
  @page_size 50

  def get_random_link(playlist_id, api_key) do
    playlist_size = get_playlist_size(playlist_id, api_key)

    link_index = random_index(playlist_size)

    get_nth_link(link_index, playlist_id, api_key)
  end

  def get_playlist_size(playlist_id, api_key) do
    RandomV.YoutubeApi.get_playlist(playlist_id, api_key)
    |> Map.get("items")
    |> List.first()
    |> Map.get("contentDetails")
    |> Map.get("itemCount")
  end

  def random_index(n) do
    Enum.random(0..(n - 1))
  end

  def get_nth_link(index, playlist_id, api_key) do
    video_id = get_nth_video_id(index, playlist_id, api_key)
    "https://youtube.com/watch?v=#{video_id}"
  end

  def get_nth_video_id(index, playlist_id, api_key) do
    page_index = get_page_index(index, @page_size)

    page = get_page(page_index, playlist_id, api_key)

    page
    |> Map.get("items")
    |> Enum.at(get_item_index(index, @page_size))
    |> Map.get("contentDetails")
    |> Map.get("videoId")
  end

  def get_page_index(n, page_size) do
    div(n, page_size)
  end

  def get_page(page_index, playlist_id, api_key) do
    Enum.reduce(0..(page_index - 1), first_page(playlist_id, api_key), fn _x, page ->
      next_page_token = Map.get(page, "nextPageToken")
      # IO.inspect("it: #{x}, nextPageToken: #{next_page_token}")
      next_page(next_page_token, playlist_id, api_key)
    end)
  end

  def first_page(playlist_id, api_key) do
    RandomV.YoutubeApi.list_playlist_items(playlist_id, api_key, @page_size)
  end

  def next_page(page_token, playlist_id, api_key) do
    RandomV.YoutubeApi.list_playlist_items(playlist_id, api_key, @page_size, page_token)
  end

  def get_item_index(n, page_size) do
    rem(n, page_size)
  end
end
