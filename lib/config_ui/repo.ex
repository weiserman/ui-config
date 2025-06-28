defmodule ConfigUi.Repo do
  use Ecto.Repo,
    otp_app: :config_ui,
    adapter: Ecto.Adapters.SQLite3
end
