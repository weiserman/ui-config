defmodule ConfigUiWeb.ViewLive do
  use ConfigUiWeb, :live_view
  
  alias ConfigUiWeb.{DynamicRenderer, SharedTemplates, SharedEventHandlers}

  def mount(params, _session, socket) do
    template_key = params["template"] || "contact_form"
    selected_config = SharedTemplates.get_template(template_key) || SharedTemplates.get_default_template()

    {:ok,
     socket
     |> assign(:selected_template, template_key)
     |> assign(:config, selected_config)
     |> assign(:event_message, nil)}
  end

  def handle_event("select_template", %{"template" => template_key}, socket) do
    case SharedTemplates.get_template(template_key) do
      nil ->
        {:noreply, socket}

      template_config ->
        {:noreply,
         socket
         |> assign(:selected_template, template_key)
         |> assign(:config, template_config)}
    end
  end

  def handle_event("form_submit", _params, socket) do
    SharedEventHandlers.handle_form_submit(socket)
  end

  def handle_event("button_click", %{"action" => action}, socket) do
    SharedEventHandlers.handle_button_click(socket, action)
  end

  def handle_event("nav_item_click", %{"action" => action, "label" => label}, socket) do
    SharedEventHandlers.handle_nav_item_click(socket, action, label)
  end

  def handle_event("clear_message", _params, socket) do
    SharedEventHandlers.handle_clear_message(socket)
  end
end