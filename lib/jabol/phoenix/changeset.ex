defmodule Jabol.Phoenix.Changeset do
  @moduledoc """
  Provides changeset functionality similar to Ecto.Changeset for data validation
  and transformation in Phoenix applications.
  """
  
  defstruct data: nil, params: %{}, changes: %{}, errors: [], valid?: true, action: nil
  
  @type t :: %__MODULE__{
    data: struct() | nil,
    params: map(),
    changes: map(),
    errors: list({atom(), {String.t(), list()}}),
    valid?: boolean(),
    action: atom() | nil
  }
  
  @doc """
  Creates a changeset for the given data and params.
  
  ## Examples
  
      iex> changeset = Jabol.Phoenix.Changeset.cast(%User{}, %{"name" => "John"}, [:name, :age])
      iex> changeset.changes
      %{name: "John"}
  """
  @spec cast(struct(), map(), list(atom())) :: t()
  def cast(data, params, permitted) do
    params = convert_params(params)
    
    changes =
      params
      |> Map.take(Enum.map(permitted, &to_string/1))
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      |> Map.take(permitted)
    
    %__MODULE__{
      data: data,
      params: params,
      changes: changes
    }
  end
  
  @doc """
  Adds a validation error if the given field does not satisfy the given predicate.
  
  ## Examples
  
      iex> changeset = Jabol.Phoenix.Changeset.cast(%User{}, %{"age" => 15}, [:age])
      iex> changeset = Jabol.Phoenix.Changeset.validate_number(changeset, :age, greater_than: 18)
      iex> changeset.valid?
      false
  """
  @spec validate_required(t(), list(atom())) :: t()
  def validate_required(changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, fn field, acc ->
      case get_change(acc, field) do
        nil -> add_error(acc, field, "can't be blank")
        "" -> add_error(acc, field, "can't be blank")
        _ -> acc
      end
    end)
  end
  
  @doc """
  Validates that the given field is a number and meets additional criteria.
  """
  @spec validate_number(t(), atom(), keyword()) :: t()
  def validate_number(changeset, field, opts) do
    value = get_change(changeset, field)
    
    cond do
      is_nil(value) ->
        changeset
      not is_number(value) ->
        add_error(changeset, field, "must be a number")
      Keyword.has_key?(opts, :greater_than) and value <= opts[:greater_than] ->
        add_error(changeset, field, "must be greater than #{opts[:greater_than]}")
      Keyword.has_key?(opts, :less_than) and value >= opts[:less_than] ->
        add_error(changeset, field, "must be less than #{opts[:less_than]}")
      true ->
        changeset
    end
  end
  
  @doc """
  Gets a change from the changeset.
  """
  @spec get_change(t(), atom()) :: any()
  def get_change(changeset, field) do
    Map.get(changeset.changes, field)
  end
  
  @doc """
  Adds an error to the changeset.
  """
  @spec add_error(t(), atom(), String.t(), list()) :: t()
  def add_error(changeset, field, message, opts \\ []) do
    %{changeset |
      errors: [{field, {message, opts}} | changeset.errors],
      valid?: false
    }
  end
  
  @doc """
  Applies the changeset changes to the data.
  """
  @spec apply_changes(t()) :: struct()
  def apply_changes(%__MODULE__{data: data, changes: changes}) do
    Enum.reduce(changes, data, fn {k, v}, acc ->
      Map.put(acc, k, v)
    end)
  end
  
  defp convert_params(params) when is_map(params) do
    params
  end
  defp convert_params(params) do
    Map.new(params)
  end
end
