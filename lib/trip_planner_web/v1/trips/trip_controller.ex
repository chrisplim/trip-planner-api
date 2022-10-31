defmodule TripPlannerWeb.V1.Trips.TripController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser
  use TripPlannerWeb.V1.OpenApi.OpenApiOperation

  alias TripPlanner.Schemas.User
  alias TripPlanner.Trips.TripPolicy
  alias TripPlanner.Trips.Trips
  alias TripPlannerWeb.FallbackController

  action_fallback(FallbackController)

  @doc """
  OpenApi spec for the index action
  """
  def index_operation do
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

  def index(conn, _, %User{} = user) do
    with {:ok, trips} <- Trips.get_all_trips_including_user(user) do
      render(conn, "trips.json", %{trips: trips})
    end
  end

  @doc """
  OpenApi spec for the create action
  """
  def create_operation do
    %Operation{
      tags: ["trips"],
      summary: "Create a trip",
      description: "Create a trip",
      operationId: "TripController.create",
      security: [%{"authorization" => []}],
      requestBody:
        request_body(
          "The attributes needed to create a new trip",
          "application/json",
          OpenApiSchemas.NewTripRequest,
          required: true
        ),
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

  def create(conn, attrs, %User{} = user) do
    with {:ok, trip} <- Trips.create_trip(user, attrs) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the show action
  """
  def show_operation do
    %Operation{
      tags: ["trips"],
      summary: "Get a trip by an ID",
      description: "Get a trip by an ID",
      operationId: "TripController.show",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        }
      ],
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

  def show(conn, %{"trip_id" => trip_id}, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip_with_activities_preloads(user, trip_id),
         :ok <- Bodyguard.permit(TripPolicy, :see_trip, user, trip) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the update action
  """
  def update_operation do
    %Operation{
      tags: ["trips"],
      summary: "Update a specific trip",
      description: "Update a specific trip",
      operationId: "TripController.update",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        }
      ],
      requestBody:
        request_body(
          "The attributes needed to update a trip",
          "application/json",
          OpenApiSchemas.UpdateTripRequest,
          required: false
        ),
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

  def update(conn, %{"trip_id" => trip_id} = attrs, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         :ok <- Bodyguard.permit(TripPolicy, :update_trip, user, trip),
         {:ok, trip} <- Trips.update_trip(user, trip, attrs) do
      render(conn, "trip.json", %{trip: trip})
    end
  end

  @doc """
  OpenApi spec for the delete action
  """
  def delete_operation do
    %Operation{
      tags: ["trips"],
      summary: "Delete a specific trip",
      description: "Delete a specific trip",
      operationId: "TripController.delete",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        }
      ],
      responses: %{
        204 =>
          response(
            "204",
            nil,
            OpenApiSchemas.OkResponse
          )
      }
    }
  end

  def delete(conn, %{"trip_id" => trip_id}, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         :ok <- Bodyguard.permit(TripPolicy, :delete_trip, user, trip),
         {:ok, _} <- Trips.delete_trip(trip) do
      send_resp(conn, 204, "")
    end
  end
end
