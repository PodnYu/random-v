defmodule RandomVTest do
  use ExUnit.Case
  alias RandomV.LinkService

  test "LinkService.get_page_index" do
    assert LinkService.get_page_index(48, 50) == 0
    assert LinkService.get_page_index(50, 50) == 1
    assert LinkService.get_page_index(100, 50) == 2
    assert LinkService.get_page_index(149, 50) == 2
  end

  test "LinkService.to_page_index" do
    assert LinkService.get_item_index(51, 50) == 1
    assert LinkService.get_item_index(61, 50) == 11
    assert LinkService.get_item_index(99, 50) == 49
    assert LinkService.get_item_index(100, 50) == 0
  end
end
