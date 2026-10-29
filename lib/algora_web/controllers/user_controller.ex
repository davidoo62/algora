defmodule AlgoraWeb.UserController do
  use AlgoraWeb, :controller

  alias Algora.Accounts.User
  alias Algora.Repo

  def index(conn, %{"handle" => handle}) do
    user = Repo.get_by(User, handle: handle)

    case user do
      nil ->
        # TODO: redirect to go page
        raise AlgoraWeb.NotFoundError

      %{type: :individual} ->
        redirect(conn, to: "/#{handle}/profile")

      %{type: :organization} ->
        redirect(conn, to: "/#{handle}/dashboard")

      _ ->
        raise AlgoraWeb.NotFoundError
    end
  end

  def profile(conn, _params) do
    case conn.assigns[:current_user] do
      %{handle: handle} when is_binary(handle) ->
        redirect(conn, to: "/#{handle}/profile")

      _ ->
        conn
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: ~p"/auth/login?return_to=/profile")
    end
  end
end
