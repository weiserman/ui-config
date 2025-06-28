defmodule ConfigUiWeb.DynamicRenderer do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto">
      <.render_component config={@config} />
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "form"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <%= if @config["title"] do %>
        <h3 class="text-lg font-semibold text-gray-900 mb-6">{@config["title"]}</h3>
      <% end %>

      <form phx-submit="form_submit" class="space-y-4">
        <%= for component <- @config["components"] || [] do %>
          <.render_component config={component} />
        <% end %>
      </form>
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "container"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <%= if @config["title"] do %>
        <h3 class="text-lg font-semibold text-gray-900 mb-6">{@config["title"]}</h3>
      <% end %>

      <div class="space-y-4">
        <%= for component <- @config["components"] || [] do %>
          <.render_component config={component} />
        <% end %>
      </div>
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "text_input"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div>
      <%= if @config["label"] do %>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          {@config["label"]}{if @config["required"], do: " *"}
        </label>
      <% end %>
      <input
        type="text"
        name={@config["name"] || "text_input"}
        required={@config["required"] || false}
        class="w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      />
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "email_input"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div>
      <%= if @config["label"] do %>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          {@config["label"]}{if @config["required"], do: " *"}
        </label>
      <% end %>
      <input
        type="email"
        name={@config["name"] || "email_input"}
        required={@config["required"] || false}
        class="w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      />
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "select"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div>
      <%= if @config["label"] do %>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          {@config["label"]}{if @config["required"], do: " *"}
        </label>
      <% end %>
      <select
        name={@config["name"] || "select"}
        required={@config["required"] || false}
        class="w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      >
        <%= for option <- @config["options"] || [] do %>
          <option value={option}>{option}</option>
        <% end %>
      </select>
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "textarea"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div>
      <%= if @config["label"] do %>
        <label class="block text-sm font-medium text-gray-700 mb-1">
          {@config["label"]}{if @config["required"], do: " *"}
        </label>
      <% end %>
      <textarea
        name={@config["name"] || "textarea"}
        rows={@config["rows"] || 3}
        required={@config["required"] || false}
        class="w-full border border-gray-300 rounded-md px-3 py-2 text-gray-900 bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      ></textarea>
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "button"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <%= if @config["action"] == "submit" do %>
      <button
        type="submit"
        class="w-full bg-blue-600 text-white rounded-md px-4 py-2 font-medium hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors"
      >
        {@config["label"] || "Submit"}
      </button>
    <% else %>
      <button
        type="button"
        phx-click="button_click"
        phx-value-action={@config["action"]}
        class="bg-blue-600 text-white rounded-md px-4 py-2 font-medium hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors mr-2"
      >
        {@config["label"] || "Button"}
      </button>
    <% end %>
    """
  end

  defp render_component(%{config: %{"type" => "header"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    level = @config["level"] || 1

    ~H"""
    <%= case level do %>
      <% 1 -> %>
        <h1 class="text-2xl font-bold text-gray-900 mb-4">{@config["text"] || "Header"}</h1>
      <% 2 -> %>
        <h2 class="text-xl font-semibold text-gray-900 mb-3">{@config["text"] || "Header"}</h2>
      <% 3 -> %>
        <h3 class="text-lg font-medium text-gray-900 mb-2">{@config["text"] || "Header"}</h3>
      <% _ -> %>
        <h4 class="text-base font-medium text-gray-900 mb-2">{@config["text"] || "Header"}</h4>
    <% end %>
    """
  end

  defp render_component(%{config: %{"type" => "paragraph"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <p class="text-gray-700 mb-4">{@config["text"] || "Paragraph text"}</p>
    """
  end

  defp render_component(%{config: config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div class="p-3 bg-red-50 border border-red-200 rounded-md">
      <p class="text-sm text-red-800">
        Unknown component type: {inspect(@config["type"])}
      </p>
    </div>
    """
  end
end
