defmodule ConfigUiWeb.SharedEventHandlers do
  @moduledoc """
  Shared event handlers for ConfigUI LiveViews.
  """

  def handle_form_submit(socket) do
    {:noreply, assign(socket, :event_message, "Form submitted successfully!")}
  end

  def handle_button_click(socket, action) do
    {:noreply, assign(socket, :event_message, "Event fired: #{action}")}
  end

  def handle_nav_item_click(socket, action, label) do
    action = if action == "", do: "no_action", else: action
    {:noreply, assign(socket, :event_message, "Navigation clicked: #{label} (#{action})")}
  end

  def handle_clear_message(socket) do
    {:noreply, assign(socket, :event_message, nil)}
  end

  def handle_template_selection(socket, template_key, templates) do
    case Map.get(templates, template_key) do
      nil ->
        {:noreply, socket}

      template_config ->
        {:noreply,
         socket
         |> assign(:selected_template, template_key)
         |> assign(:config, template_config)
         |> assign(:config_json, Jason.encode!(template_config, pretty: true))
         |> assign(:parsed_config, template_config)
         |> assign(:json_error, nil)}
    end
  end
end