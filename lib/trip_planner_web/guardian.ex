defmodule TripPlannerWeb.Guardian do
  use Guardian, otp_app: :trip_planner

  alias TripPlanner.Users.Users
  alias TripPlanner.Schemas.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, "Not found"}
  end

  def resource_from_claims(%{"sub" => user_id}) do
    case Users.get_user(user_id) do
      {:ok, user} -> {:ok, user}
      _ -> {:error, :resource_not_found}
    end
  end

  def resource_from_claims(_claims) do
    {:error, "No subject"}
  end
end
