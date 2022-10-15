# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule TripPlannerWeb.V1.OpenApi.OpenApiSchemas do
  @moduledoc """
  Defines the OpenApi schemas for endpoints in our app
  """
  alias OpenApiSpex.Schema
  require OpenApiSpex

  defmodule RegisterUserRequest do
    OpenApiSpex.schema(%{
      description: "User information",
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
    OpenApiSpex.schema(%{
      description: "User information",
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
    OpenApiSpex.schema(%{
      description: "Current User information",
      type: :object,
      properties: %{
        user: UserResponse
      }
    })
  end

  defmodule LoginRequest do
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

  defmodule RefreshTokenRequest do
    OpenApiSpex.schema(%{
      description: "Refresh token request body",
      type: :object,
      properties: %{
        refresh_token: %Schema{
          type: :string,
          description: "Refresh token to get a new refresh token"
        }
      },
      required: [:refresh_token],
      example: %{
        "refresh_token" => "<refresh_token>"
      }
    })
  end

  defmodule TripId do
    OpenApiSpex.schema(%{
      description: "Trip id",
      type: :string,
      example: "3a8c6f21-0fac-4705-98c3-e1f7d5e2cd6d"
    })
  end

  defmodule NewTripRequest do
    OpenApiSpex.schema(%{
      description: "Trip information",
      type: :object,
      properties: %{
        name: %Schema{
          type: :string,
          description: "Name",
          pattern: ~r/[a-zA-Z]+/
        },
        description: %Schema{
          type: :string,
          description: "Description",
          pattern: ~r/[a-zA-Z]*/
        },
        start_date: %Schema{
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        }
      },
      required: [:name],
      example: %{
        "name" => "Hawaii",
        "description" => "Let's go to Hawaii",
        "start_date" => 1_664_422_123,
        "end_date" => 1_664_422_123
      }
    })
  end

  defmodule UpdateTripRequest do
    OpenApiSpex.schema(%{
      description: "Update Trip information",
      type: :object,
      properties: %{
        name: %Schema{
          type: :string,
          description: "Name",
          pattern: ~r/[a-zA-Z]+/
        },
        description: %Schema{
          type: :string,
          description: "Description",
          pattern: ~r/[a-zA-Z]*/
        },
        start_date: %Schema{
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        }
      },
      example: %{
        "name" => "New Hawaii",
        "description" => "Let's go to New Hawaii",
        "start_date" => 1_664_422_123,
        "end_date" => 1_664_422_123
      }
    })
  end

  defmodule TripResponse do
    OpenApiSpex.schema(%{
      description: "Trip information",
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
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        },
        owner: UserResponse
      },
      example: %{
        "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
        "name" => "Hawaii Trip",
        "description" => "Let's have fun",
        "start_date" => 1_664_422_123,
        "end_date" => 1_664_422_123,
        "owner" => %{
          "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
          "first_name" => "Joe",
          "last_name" => "Bruin",
          "username" => "joebruin",
          "email" => "joebruin@gmail.com",
          "phone" => "3101234567"
        },
        "users" => [
          %{
            "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
            "first_name" => "Joe",
            "last_name" => "Bruin",
            "username" => "joebruin",
            "email" => "joebruin@gmail.com",
            "phone" => "3101234567"
          }
        ]
      }
    })
  end

  defmodule TripsResponse do
    OpenApiSpex.schema(%{
      description: "Trip Information List",
      type: :array,
      items: TripResponse
    })
  end

  defmodule OkResponse do
    OpenApiSpex.schema(%{
      description: "200 OK response",
      type: :string,
      example: "OK"
    })
  end

  defmodule ActivityId do
    OpenApiSpex.schema(%{
      description: "Activity id",
      type: :string,
      example: "4a8c6f21-0fac-4705-98c3-e1f7d5e2cd6d"
    })
  end

  defmodule TripPlannerMoney do
    OpenApiSpex.schema(%{
      description: "Money object",
      type: :object,
      properties: %{
        amount: %Schema{type: :integer, description: "Amount"},
        currency: %Schema{type: :string, description: "Currency Code"}
      }
    })
  end

  defmodule NewActivityRequest do
    OpenApiSpex.schema(%{
      description: "New Activity information",
      type: :object,
      properties: %{
        name: %Schema{
          type: :string,
          description: "Name",
          pattern: ~r/[a-zA-Z]+/
        },
        website: %Schema{
          type: :string,
          description: "Website"
        },
        location: %Schema{
          type: :string,
          description: "Location"
        },
        phone: %Schema{
          type: :string,
          description: "Phone"
        },
        price_per_person: TripPlannerMoney,
        notes: %Schema{
          type: :string,
          description: "Notes"
        },
        start_date: %Schema{
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        }
      },
      required: [:name],
      example: %{
        "name" => "Hawaii",
        "website" => "http://example.com",
        "location" => "At my house",
        "phone" => "3101234567",
        # 10.00 USD
        "price_per_person" => %{"amount" => 1000, "currency" => "USD"},
        "notes" => "some note",
        "start_date" => 1_664_422_123,
        "end_date" => 1_664_422_123
      }
    })
  end

  defmodule UpdateActivityRequest do
    OpenApiSpex.schema(%{
      description: "Update Activity Request information",
      type: :object,
      properties: %{
        name: %Schema{
          type: :string,
          description: "Name",
          pattern: ~r/[a-zA-Z]+/
        },
        website: %Schema{
          type: :string,
          description: "Website"
        },
        location: %Schema{
          type: :string,
          description: "Location"
        },
        phone: %Schema{
          type: :string,
          description: "Phone"
        },
        price_per_person: TripPlannerMoney,
        notes: %Schema{
          type: :string,
          description: "Notes"
        },
        start_date: %Schema{
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        }
      },
      example: %{
        "name" => "New Hawaii",
        "website" => "http://example.com",
        "location" => "New place",
        "phone" => "3101234567",
        # 40.00 USD
        "price_per_person" => %{"amount" => 4000, "currency" => "USD"},
        "notes" => "some updated note",
        "start_date" => 1_664_422_129,
        "end_date" => 1_664_422_129
      }
    })
  end

  defmodule ActivityResponse do
    OpenApiSpex.schema(%{
      description: "Activity information",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid, description: "Activity ID"},
        name: %Schema{
          type: :string,
          description: "Name"
        },
        website: %Schema{
          type: :string,
          description: "Website"
        },
        location: %Schema{
          type: :string,
          description: "Location"
        },
        phone: %Schema{
          type: :string,
          description: "Phone"
        },
        price_per_person: TripPlannerMoney,
        price_per_person_string: %Schema{
          type: :string,
          format: "<currency_symbol><amount>",
          description: "Price per person in string form"
        },
        notes: %Schema{
          type: :string,
          description: "Notes"
        },
        start_date: %Schema{
          type: :integer,
          description: "Start Date"
        },
        end_date: %Schema{
          type: :integer,
          description: "End Date"
        },
        user: UserResponse,
        trip_id: TripId
      },
      example: %{
        "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
        "name" => "Fun Activity",
        "website" => "http://example.com",
        "location" => "At my house",
        "phone" => "3101234567",
        # 10.00 USD
        "price_per_person" => %{"amount" => 1000, "currency" => "USD"},
        "price_per_person_string" => "$10.00",
        "notes" => "some note",
        "start_date" => 1_664_422_123,
        "end_date" => 1_664_422_123,
        "user" => %{
          "id" => "02ef9c5f-29e6-48fc-9ec3-7ed57ed351f6",
          "first_name" => "Joe",
          "last_name" => "Bruin",
          "username" => "joebruin",
          "email" => "joebruin@gmail.com",
          "phone" => "3101234567"
        },
        "trip_id" => "3a8c6f21-0fac-4705-98c3-e1f7d5e2cd6d"
      }
    })
  end
end
