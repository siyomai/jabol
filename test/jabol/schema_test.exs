defmodule Jabol.SchemaTest do
  use ExUnit.Case
  
  defmodule TestSchema do
    use Jabol.Schema
    
    schema "test_table" do
      field :name, :string
      field :age, :integer
      timestamps()
    end
  end
  
  test "schema defines source" do
    assert TestSchema.__schema__(:source) == "test_table"
  end
  
  test "schema can be instantiated as a struct" do
    # Create an instance with values for the struct fields
    person = %TestSchema{name: "John", age: 30}
    assert person.name == "John"
    assert person.age == 30
  end
  
  test "field type can be retrieved" do
    assert TestSchema.__schema__(:field, :name) == :string
    assert TestSchema.__schema__(:field, :age) == :integer
  end
  
  test "timestamps fields are defined" do
    person = %TestSchema{}
    assert Map.has_key?(person, :inserted_at)
    assert Map.has_key?(person, :updated_at)
  end
end
