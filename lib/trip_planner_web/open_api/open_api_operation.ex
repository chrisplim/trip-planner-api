defmodule TripPlannerWeb.OpenApi.OpenApiOperation do
  @doc """
  Defines a macro to be used in the controllers for defining the open_api_operation/1 function.
  """
  defmacro __using__(_) do
    quote do
      alias OpenApiSpex.Operation
      alias OpenApiSpex.Parameter
      alias TripPlannerWeb.OpenApi.OpenApiSchemas
      import OpenApiSpex.Operation, only: [parameter: 5, request_body: 4, response: 3]

      @doc """
      This function takes an `action` atom that is the MVC controller action's function
      name, and returns the `%Operation{}` struct for that action.
      """
      def open_api_operation(action) do
        apply(__MODULE__, :"#{action}_operation", [])
      end
    end
  end
end
