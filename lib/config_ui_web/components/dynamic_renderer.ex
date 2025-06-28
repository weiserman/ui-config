defmodule ConfigUiWeb.DynamicRenderer do
  use Phoenix.Component
  import ConfigUiWeb.CoreComponents, only: [icon: 1]

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

  defp render_component(%{config: %{"type" => "navigation"} = config} = assigns) do
    assigns = assign(assigns, :config, config)

    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
      <%= if @config["title"] do %>
        <div class="px-4 py-3 border-b border-gray-200 bg-gray-50">
          <h3 class="text-sm font-semibold text-gray-900">{@config["title"]}</h3>
        </div>
      <% end %>

      <nav class="py-2">
        <%= for item <- @config["items"] || [] do %>
          <.render_nav_item item={item} level={0} />
        <% end %>
      </nav>
    </div>
    """
  end

  defp render_nav_item(assigns) do
    assigns = assign(assigns, :has_children, has_children?(assigns.item))

    ~H"""
    <div class="nav-item-container">
      <!-- Main nav item -->
      <div class={[
        "flex items-center justify-between px-4 py-2 text-sm hover:bg-gray-50 cursor-pointer transition-colors",
        get_indent_classes(@level)
      ]}>
        <div
          class="flex items-center flex-1"
          phx-click="nav_item_click"
          phx-value-action={@item["action"]}
          phx-value-label={@item["label"]}
        >
          <%= if @item["icon"] do %>
            <.icon name={@item["icon"]} class="w-4 h-4 mr-3 text-gray-500" />
          <% end %>
          <span class="text-gray-900">{@item["label"]}</span>
        </div>

        <%= if @has_children do %>
          <button
            type="button"
            class="p-1 hover:bg-gray-100 rounded"
            phx-click={JS.toggle(to: "#nav-children-#{generate_id(@item)}")}
          >
            <.icon name="hero-chevron-down" class="w-3 h-3 text-gray-400 transition-transform" />
          </button>
        <% end %>
      </div>
      
    <!-- Children (collapsible) -->
      <%= if @has_children do %>
        <div id={"nav-children-#{generate_id(@item)}"} class="block">
          <%= for child <- @item["children"] do %>
            <.render_nav_item item={child} level={@level + 1} />
          <% end %>
        </div>
      <% end %>
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
    assigns =
      assigns
      |> assign(:config, config)
      |> assign(:level, config["level"] || 1)

    ~H"""
    <%= case @level do %>
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

  # Helper functions
  defp has_children?(item) do
    case item["children"] do
      children when is_list(children) and length(children) > 0 -> true
      _ -> false
    end
  end

  defp get_indent_classes(0), do: ""
  defp get_indent_classes(1), do: "pl-8"
  defp get_indent_classes(2), do: "pl-12"
  defp get_indent_classes(3), do: "pl-16"
  defp get_indent_classes(level) when level > 3, do: "pl-20"

  defp generate_id(item) do
    item["label"]
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end
end
