defmodule JabolTest do
  use ExUnit.Case
  doctest Jabol

  test "project modules are properly defined" do
    assert Code.ensure_loaded?(Jabol.Schema)
    assert Code.ensure_loaded?(Jabol.Repo)
    assert Code.ensure_loaded?(Jabol.Person)
  end
end