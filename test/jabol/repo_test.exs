defmodule Jabol.RepoTest do
  use ExUnit.Case
  
  alias Jabol.{Repo, Factory, Person}
  
  setup do
    # Setup a test database connection
    {:ok, config} = Repo.init([])
    %{config: config}
  end
  
  test "can insert a record", %{config: _config} do
    attrs = %{name: "Jane", gender: "female", age: 25}
    {:ok, record} = Repo.insert(Person, attrs)
    
    assert record.name == "Jane"
    assert record.gender == "female"
    assert record.age == 25
  end
  
  test "can get a record by id", %{config: _config} do
    record = Repo.get(Person, 1)
    
    assert record.id == 1
  end
  
  test "can update a record", %{config: _config} do
    # Use the factory to build a struct
    person = Factory.build(Person, %{id: 1, name: "Original", age: 20})
    {:ok, updated} = Repo.update(person, %{name: "Updated"})
    
    assert updated.name == "Updated"
    assert updated.age == 20
  end
  
  test "can delete a record", %{config: _config} do
    # Use the factory to build a struct
    person = Factory.build(Person, %{id: 1, name: "To Delete"})
    {:ok, deleted} = Repo.delete(person)
    
    assert deleted.id == 1
  end
  
  test "factory can build records" do
    person = Factory.build(Person)
    assert person.name == "John Doe"
    assert person.gender == "male"
    assert person.age == 30
  end
  
  test "factory can build records with custom attributes" do
    person = Factory.build(Person, %{name: "Custom Name"})
    assert person.name == "Custom Name"
    assert person.gender == "male"  # Default still applies
  end
  
  test "factory can build lists of records" do
    people = Factory.build_list(3, Person)
    assert length(people) == 3
    assert Enum.all?(people, fn p -> p.name == "John Doe" end)
  end
end
