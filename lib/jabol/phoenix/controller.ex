defmodule Jabol.Phoenix.Controller do
  @moduledoc """
  Provides controller helpers for using Jabol with Phoenix.
  """

  @doc """
  Loads the resource and assigns it to conn.

  Similar to `Phoenix.Controller.action_fallback/1` but for Jabol schemas.
  """
  defmacro __using__(_opts) do
    quote do
      import Jabol.Phoenix.Controller

      @doc """
      A helper to load a schema by ID from the database.

      ## Examples

          def show(conn, %{"id" => id}) do
            case load_resource(MyApp.User, id) do
              nil ->
                conn
                |> put_status(:not_found)
                |> render("error.json", message: "Resource not found")
              user ->
                render(conn, "show.json", user: user)
            end
          end
      """
      def load_resource(schema, id) do
        Jabol.Repo.get(schema, id)
      end
    end
  end
end
