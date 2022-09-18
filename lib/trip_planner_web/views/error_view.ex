defmodule TripPlannerWeb.ErrorView do
  use TripPlannerWeb, :view

  def render("error.json", %{message: message, code: code}) do
    %{
      error: %{
        code: code,
        message: message
      }
    }
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{error: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
