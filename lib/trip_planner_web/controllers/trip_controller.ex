defmodule TripPlannerWeb.TripController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser
  use TripPlannerWeb.OpenApi.OpenApiOperation

  alias TripPlanner.Schemas.User
  alias TripPlanner.Trips.Trips
  alias TripPlannerWeb.FallbackController

  action_fallback(FallbackController)

  @doc """
  OpenApi spec for the index action
  """
  def index_operation() do
    %Operation{
      tags: ["trips"],
      summary: "Get all trips of current user",
      description: "Get all trips of current user",
      operationId: "TripController.index",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "List of trips of current user",
            "application/json",
            OpenApiSchemas.TripsResponse
          )
      }
    }
  end

  def index(conn, _, %User{} = current_user) do
    with {:ok, trips} <- Trips.get_all_trips_including_user(current_user) do
      render(conn, "trips.json", %{trips: trips})
    end
  end

  @doc """
  OpenApi spec for the create action
  """
  def create_operation() do
    %Operation{
      tags: ["trips"],
      summary: "Create a trip",
      description: "Create a trip",
      operationId: "TripController.create",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "Info of the created trip",
            "application/json",
            OpenApiSchemas.TripResponse
          )
      }
    }
  end

  def create(conn, attrs, %User{} = current_user) do
    with {:ok, trip} <- Trips.create_trip(current_user, attrs) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the show action
  """
  def show_operation() do
    %Operation{
      tags: ["trips"],
      summary: "Get a trip by an ID",
      description: "Get a trip by an ID",
      operationId: "TripController.show",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "Info of the trip",
            "application/json",
            OpenApiSchemas.TripResponse
          )
      }
    }
  end

  def show(conn, %{"trip_id" => trip_id}, %User{} = _current_user) do
    # TODO can user see this trip?
    with {:ok, trip} <- Trips.get_trip(trip_id) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the update action
  """
  def update_operation() do
    %Operation{
      tags: ["trips"],
      summary: "Update a specific trip",
      description: "Update a specific trip",
      operationId: "TripController.update",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "Info of the updated trip",
            "application/json",
            OpenApiSchemas.TripResponse
          )
      }
    }
  end

  def update(conn, %{"trip_id" => trip_id} = attrs, %User{} = _current_user) do
    # TODO can user get+update this trip?
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, trip} <- Trips.update_trip(trip, attrs) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the delete action
  """
  def delete_operation() do
    %Operation{
      tags: ["trips"],
      summary: "Delete a specific trip",
      description: "Delete a specific trip",
      operationId: "TripController.delete",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "200 OK",
            "application/json",
            OpenApiSchemas.OkResponse
          )
      }
    }
  end

  def delete(conn, %{"trip_id" => trip_id}, %User{} = _current_user) do
    # TODO can user delete this trip?
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, _} <- Trips.delete_trip(trip) do
      conn |> send_resp(200, "OK")
    end
  end
end
