defmodule TripPlannerWeb.UserView do
  use TripPlannerWeb, :view

  # alias TripPlannerWeb.GovernmentIdView
  # alias TripPlannerWeb.MedicalRecommendationView

  # def render("user_auth.json", %{user: user, tokens: tokens}) do
  #   %{user: render_one(user, __MODULE__, "user.json", as: :user), tokens: tokens}
  # end

  # def render("user_profile.json", %{user: user}) do
  #   %{
  #     user: render_one(user, __MODULE__, "user.json", as: :user),
  #     medical_recommendation:
  #       render_one(
  #         user.medical_recommendation,
  #         MedicalRecommendationView,
  #         "medical_recommendation.json",
  #         as: :medical_recommendation
  #       ),
  #     government_id:
  #       render_one(user.government_id, GovernmentIdView, "government_id.json", as: :government_id)
  #   }
  # end

  def render("user.json", %{user: user}) do
    %{id: user.id, first_name: user.first_name, email: user.email, username: user.username}
  end
end
