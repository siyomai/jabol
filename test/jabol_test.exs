defmodule JabolTest do
  use ExUnit.Case
  doctest Jabol

  test "greets the world" do
    assert Jabol.hello() == :world
  end

  test "project modules are properly defined" do
    assert Code.ensure_loaded?(Jabol.Schema)
    assert Code.ensure_loaded?(Jabol.Repo)
    assert Code.ensure_loaded?(Jabol.Person)
  end
end
