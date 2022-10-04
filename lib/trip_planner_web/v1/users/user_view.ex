defmodule TripPlannerWeb.V1.Users.UserView do
  use TripPlannerWeb, :view

  def render("user_auth.json", %{user: user, tokens: tokens}) do
    %{user: render_one(user, __MODULE__, "user.json", as: :user), tokens: tokens}
  end

  def render("user_profile.json", %{user: user}) do
    %{
      user: render_one(user, __MODULE__, "user.json", as: :user)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      username: user.username,
      email: user.email,
      phone: user.phone
    }
  end
end
