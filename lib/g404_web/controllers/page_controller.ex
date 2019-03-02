defmodule G404Web.PageController do
  use G404Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
