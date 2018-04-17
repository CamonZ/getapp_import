defmodule ImportTest do
  use ExUnit.Case
  doctest Import

  test "greets the world" do
    assert Import.hello() == :world
  end
end
