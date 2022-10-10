defmodule TripPlannerWeb.V1.Trips.ActivityController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser
  use TripPlannerWeb.V1.OpenApi.OpenApiOperation

  alias TripPlanner.Schemas.User
  alias TripPlanner.Trips.Activities
  alias TripPlanner.Trips.ActivityPolicy
  alias TripPlanner.Trips.Trips
  alias TripPlannerWeb.FallbackController

  action_fallback(FallbackController)

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

  def create(conn, %{"trip_id" => trip_id} = attrs, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         :ok <- Bodyguard.permit(ActivityPolicy, :create_activity, user, trip),
         {:ok, activity} <- Activities.create_activity(user, trip, attrs) do
      render(conn, "activity.json", %{activity: activity})
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
          schema: OpenApiSchemas.TripIdPathParameter
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

  def show(conn, %{"trip_id" => trip_id, "activity_id" => activity_id}, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity(activity_id),
         :ok <- Bodyguard.permit(ActivityPolicy, :see_activity, user, %{trip: trip, activity: activity}) do
      render(conn, "activity.json", %{activity: activity})
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
          schema: OpenApiSchemas.TripIdPathParameter
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

  def update(conn, %{"trip_id" => trip_id, "activity_id" => activity_id} = attrs, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity(activity_id),
         :ok <- Bodyguard.permit(ActivityPolicy, :update_activity, user, %{trip: trip, activity: activity}),
         {:ok, activity} <- Activities.update_activity(activity, attrs) do
      render(conn, "activity.json", %{activity: activity})
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
          schema: OpenApiSchemas.TripIdPathParameter
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

  def delete(conn, %{"trip_id" => trip_id, "activity_id" => activity_id}, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity(activity_id),
         :ok <- Bodyguard.permit(ActivityPolicy, :delete_activity, user, %{trip: trip, activity: activity}),
         {:ok, _} <- Activities.delete_activity(activity) do
      send_resp(conn, 204, "")
    end
  end
end
