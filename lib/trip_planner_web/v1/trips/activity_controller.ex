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
      tags: ["activities"],
      summary: "Create an activity",
      description: "Create an activity",
      operationId: "ActivityController.create",
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
          "The attributes needed to create a new activity",
          "application/json",
          OpenApiSchemas.NewActivityRequest,
          required: true
        ),
      responses: %{
        200 =>
          response(
            "Info of the created activity",
            "application/json",
            OpenApiSchemas.ActivityResponse
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
      tags: ["activities"],
      summary: "Get a activity by an ID",
      description: "Get a activity by an ID",
      operationId: "ActivityController.show",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        },
        %Parameter{
          name: "activity_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.ActivityId
        }
      ],
      responses: %{
        200 =>
          response(
            "Info of the activity",
            "application/json",
            OpenApiSchemas.ActivityResponse
          )
      }
    }
  end

  def show(conn, %{"trip_id" => trip_id, "activity_id" => activity_id}, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity_with_interest(user, activity_id),
         :ok <-
           Bodyguard.permit(ActivityPolicy, :see_activity, user, %{trip: trip, activity: activity}) do
      render(conn, "activity.json", %{activity: activity})
    end
  end

  @doc """
  OpenApi spec for the update action
  """
  def update_operation do
    %Operation{
      tags: ["activities"],
      summary: "Update a specific activity",
      description: "Update a specific activity",
      operationId: "ActivityController.update",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        },
        %Parameter{
          name: "activity_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.ActivityId
        }
      ],
      requestBody:
        request_body(
          "The attributes needed to update a activity",
          "application/json",
          OpenApiSchemas.UpdateActivityRequest,
          required: false
        ),
      responses: %{
        200 =>
          response(
            "Info of the updated activity",
            "application/json",
            OpenApiSchemas.ActivityResponse
          )
      }
    }
  end

  def update(conn, %{"trip_id" => trip_id, "activity_id" => activity_id} = attrs, %User{} = user) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity(activity_id),
         :ok <-
           Bodyguard.permit(ActivityPolicy, :update_activity, user, %{
             trip: trip,
             activity: activity
           }),
         {:ok, activity} <- Activities.update_activity(user, activity, attrs) do
      render(conn, "activity.json", %{activity: activity})
    end
  end

  @doc """
  OpenApi spec for the delete action
  """
  def delete_operation do
    %Operation{
      tags: ["activities"],
      summary: "Delete a specific activity",
      description: "Delete a specific activity",
      operationId: "ActivityController.delete",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        },
        %Parameter{
          name: "activity_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.ActivityId
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
         :ok <-
           Bodyguard.permit(ActivityPolicy, :delete_activity, user, %{
             trip: trip,
             activity: activity
           }),
         {:ok, _} <- Activities.delete_activity(activity) do
      send_resp(conn, 204, "")
    end
  end

  @doc """
  OpenApi spec for the vote action
  """
  def vote_operation do
    %Operation{
      tags: ["activities"],
      summary: "Vote on a specific activity",
      description: "Vote on a specific activity",
      operationId: "ActivityController.vote",
      security: [%{"authorization" => []}],
      parameters: [
        %Parameter{
          name: "trip_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.TripId
        },
        %Parameter{
          name: "activity_id",
          in: "path",
          required: true,
          schema: OpenApiSchemas.ActivityId
        }
      ],
      requestBody:
        request_body(
          "The attributes needed to vote on an activity",
          "application/json",
          OpenApiSchemas.VoteOnActivityRequest,
          required: false
        ),
      responses: %{
        200 =>
          response(
            "Info of the updated activity",
            "application/json",
            OpenApiSchemas.ActivityResponse
          )
      }
    }
  end

  def vote(
        conn,
        %{"trip_id" => trip_id, "activity_id" => activity_id, "is_interested" => is_interested},
        %User{} = user
      ) do
    with {:ok, trip} <- Trips.get_trip(trip_id),
         {:ok, activity} <- Activities.get_activity(activity_id),
         :ok <-
           Bodyguard.permit(ActivityPolicy, :vote_on_activity, user, %{
             trip: trip,
             activity: activity
           }),
         {:ok, activity} <- Activities.vote_on_activity(user, activity, is_interested) do
      render(conn, "activity.json", %{activity: activity})
    end
  end
end
