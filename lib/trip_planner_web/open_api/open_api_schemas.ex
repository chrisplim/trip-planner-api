defmodule TripPlannerWeb.OpenApi.OpenApiSchemas do
  alias OpenApiSpex.Schema

  defmodule RegisterUserRequest do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Current user information",
      type: :object,
      properties: %{
        first_name: %Schema{
          type: :string,
          description: "First Name",
          pattern: ~r/[a-zA-Z][a-zA-Z]+/
        },
        last_name: %Schema{
          type: :string,
          description: "Last Name",
          pattern: ~r/[a-zA-Z][a-zA-Z]+/
        },
        username: %Schema{
          type: :string,
          description: "Username",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        password: %Schema{
          type: :string,
          description: "Password",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        email: %Schema{type: :string, description: "Email Address", format: :email},
        phone: %Schema{type: :string, description: "Phone Number"}
      },
      required: [:first_name, :last_name, :username, :password, :email],
      example: %{
        "first_name" => "Joe",
        "last_name" => "Bruin",
        "username" => "joebruin",
        "password" => "bruin1919",
        "email" => "joebruin@gmail.com",
        "phone" => "3101234567"
      }
    })
  end

  defmodule UserResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Current user information",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid, description: "User ID"},
        first_name: %Schema{
          type: :string,
          description: "First Name",
          pattern: ~r/[a-zA-Z][a-zA-Z]+/
        },
        last_name: %Schema{
          type: :string,
          description: "Last Name",
          pattern: ~r/[a-zA-Z][a-zA-Z]+/
        },
        username: %Schema{
          type: :string,
          description: "Username",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        email: %Schema{type: :string, description: "Email Address", format: :email},
        phone: %Schema{type: :string, description: "Phone Number"}
      },
      example: %{
        "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
        "first_name" => "Joe",
        "last_name" => "Bruin",
        "username" => "joebruin",
        "email" => "joebruin@gmail.com",
        "phone" => "3101234567"
      }
    })
  end

  defmodule TokensResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Authentication tokens",
      type: :object,
      properties: %{
        access_token: %Schema{type: :string, description: "authentication access token"},
        refresh_token: %Schema{type: :string, description: "authentication refresh token"}
      },
      example: %{
        "access_token" => "AYjcyMzY3ZDhiNmJkNTY",
        "refresh_token" => "RjY2NjM5NzA2OWJjuE7c"
      }
    })
  end

  defmodule UserAuthResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User and authentication information",
      type: :object,
      properties: %{
        user: UserResponse,
        tokens: TokensResponse
      }
    })
  end

  defmodule CurrentUserResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Current User information",
      type: :object,
      properties: %{
        user: UserResponse
      }
    })
  end

  defmodule LoginRequest do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Login request body",
      type: :object,
      properties: %{
        username: %Schema{
          type: :string,
          description: "Username",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        },
        password: %Schema{
          type: :string,
          description: "Password",
          pattern: ~r/[a-zA-Z][a-zA-Z0-9_]+/
        }
      },
      required: [:username, :password],
      example: %{
        "username" => "joebruin",
        "password" => "bruin1919"
      }
    })
  end

  defmodule TripResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Current User information",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid, description: "Trip ID"},
        name: %Schema{
          type: :string,
          description: "Name"
        },
        description: %Schema{
          type: :string,
          description: "Description"
        },
        start_date: %Schema{
          type: :string,
          format: :date,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :string,
          format: :date,
          description: "End Date"
        },
        owner: UserResponse
      },
      example: %{
        "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
        "name" => "Hawaii Trip",
        "description" => "Let's have fun",
        # TODO figure out what the dates look like
        "start_date" => "",
        "end_date" => "",
        "owner" => %{
          "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
          "first_name" => "Joe",
          "last_name" => "Bruin",
          "username" => "joebruin",
          "email" => "joebruin@gmail.com",
          "phone" => "3101234567"
        }
      }
    })
  end

  defmodule TripsResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Current User information",
      type: :array,
      items: TripResponse
    })
  end

  defmodule OkResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "200 OK response",
      type: :string,
      example: "OK"
    })
  end
end
