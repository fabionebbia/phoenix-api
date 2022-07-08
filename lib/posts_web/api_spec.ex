defmodule PostsWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server, Response}
  alias PostsWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Posts API",
        version: "1.0"
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      components: %Components{
        links: %{
          "ciao" => %OpenApiSpex.Link{description: "we"}
        }
      }
    }
    # Discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end

  def common_read_responses(responses) do
    responses
  end

  def common_write_responses(responses) do
    responses
  end

  def response(responses, status) when is_map(responses) and is_integer(status) do
    responses
    |> Map.put_new(status, response(status))
  end

  def response(404) do
    %Response{description: "Not found"}
  end
end
