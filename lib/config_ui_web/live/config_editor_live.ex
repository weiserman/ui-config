defmodule ConfigUiWeb.ConfigEditorLive do
  use ConfigUiWeb, :live_view
  
  alias ConfigUiWeb.{DynamicRenderer, SharedTemplates, SharedEventHandlers}

  def mount(_params, _session, socket) do
    default_config = SharedTemplates.get_default_template()

    {:ok,
     socket
     |> assign(:config_json, Jason.encode!(default_config, pretty: true))
     |> assign(:parsed_config, default_config)
     |> assign(:json_error, nil)
     |> assign(:selected_template, "contact_form")
     |> assign(:upload_error, nil)
     |> assign(:event_message, nil)
     |> allow_upload(:config_file, accept: ~w(.json), max_entries: 1)}
  end

  def handle_event("validate_config", %{"config" => config_json}, socket) do
    case Jason.decode(config_json) do
      {:ok, parsed_config} ->
        {:noreply,
         socket
         |> assign(:config_json, config_json)
         |> assign(:parsed_config, parsed_config)
         |> assign(:json_error, nil)}

      {:error, %Jason.DecodeError{} = error} ->
        {:noreply,
         socket
         |> assign(:config_json, config_json)
         |> assign(:json_error, "Invalid JSON: #{Exception.message(error)}")
         |> assign(:parsed_config, nil)}
    end
  end

  def handle_event("select_template", %{"template" => template_key}, socket) do
    SharedEventHandlers.handle_template_selection(
      socket,
      template_key,
      SharedTemplates.get_all_templates()
    )
  end

  def handle_event("validate_upload", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :config_file, ref)}
  end

  def handle_event("upload_config", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :config_file, fn %{path: path}, _entry ->
        case File.read(path) do
          {:ok, content} ->
            case Jason.decode(content) do
              {:ok, parsed_config} ->
                {:ok, {content, parsed_config}}

              {:error, error} ->
                {:postpone, "Invalid JSON file: #{Exception.message(error)}"}
            end

          {:error, _} ->
            {:postpone, "Failed to read file"}
        end
      end)

    case uploaded_files do
      [{content, parsed_config}] ->
        {:noreply,
         socket
         |> assign(:config_json, content)
         |> assign(:parsed_config, parsed_config)
         |> assign(:upload_error, nil)
         |> assign(:json_error, nil)}

      [] ->
        {:noreply, assign(socket, :upload_error, "No file uploaded")}

      errors when is_list(errors) ->
        error_msg = Enum.join(errors, ", ")
        {:noreply, assign(socket, :upload_error, error_msg)}
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