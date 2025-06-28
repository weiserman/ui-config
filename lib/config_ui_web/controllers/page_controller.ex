defmodule ConfigUiWeb.PageController do
  use ConfigUiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
