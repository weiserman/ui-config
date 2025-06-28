defmodule ConfigUiWeb.TemplateSelector do
  use Phoenix.Component
  alias ConfigUiWeb.SharedTemplates

  attr :selected_template, :string, required: true
  attr :class, :string, default: ""

  def template_select(assigns) do
    assigns = assign(assigns, :templates, get_template_options())

    ~H"""
    <form>
      <select
        phx-change="select_template"
        name="template"
        class={["border border-gray-300 rounded px-2 py-1 bg-white text-gray-700", @class]}
      >
        <%= for {key, label} <- @templates do %>
          <option value={key} selected={@selected_template == key}>
            {label}
          </option>
        <% end %>
      </select>
    </form>
    """
  end

  defp get_template_options do
    [
      {"contact_form", "Contact Form"},
      {"user_profile", "User Profile"},
      {"dashboard", "Dashboard"},
      {"navigation", "Navigation"},
      {"columns", "Columns Layout"}
    ]
  end