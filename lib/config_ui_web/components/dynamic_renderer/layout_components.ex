defmodule ConfigUiWeb.DynamicRenderer.LayoutComponents do
  use Phoenix.Component
  import ConfigUiWeb.CoreComponents, only: [icon: 1]

  def columns_layout(assigns) do
    ~H"""
    <div class={[
      "grid",
      get_column_classes(@config["columns"]),
      get_gap_classes(@config["gap"]),
      get_responsive_classes(@config["responsive"])
    ]}>
      <%= for column <- @config["columns"] || [] do %>
        <div class={[
          "flex flex-col",
          get_column_width_classes(column["width"])
        ]}>
          <%= if column["component"] do %>
            <ConfigUiWeb.DynamicRenderer.render config={column["component"]} />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def container_layout(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <%= if @config["title"] do %>
        <h3 class="text-lg font-semibold text-gray-900 mb-6">{@config["title"]}</h3>
      <% end %>

      <div class="space-y-4">
        <%= for component <- @config["components"] || [] do %>
          <ConfigUiWeb.DynamicRenderer.render config={component} />
        <% end %>
      </div>
    </div>
    """
  end

  def form_layout(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <%= if @config["title"] do %>
        <h3 class="text-lg font-semibold text-gray-900 mb-6">{@config["title"]}</h3>
      <% end %>

      <form phx-submit="form_submit" class="space-y-4">
        <%= for component <- @config["components"] || [] do %>
          <ConfigUiWeb.DynamicRenderer.render config={component} />
        <% end %>
      </form>
    </div>
    """
  end

  def navigation_layout(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
      <%= if @config["title"] do %>
        <div class="px-4 py-3 border-b border-gray-200 bg-gray-50">
          <h3 class="text-sm font-semibold text-gray-900">{@config["title"]}</h3>
        </div>
      <% end %>

      <nav class="py-2">
        <%= for item <- @config["items"] || [] do %>
          <.nav_item item={item} level={0} />
        <% end %>
      </nav>
    </div>
    """
  end

  defp nav_item(assigns) do
    assigns = assign(assigns, :has_children, has_children?(assigns.item))

    ~H"""
    <div class="nav-item-container">
      <div class={[
        "flex items-center justify-between px-4 py-2 text-sm hover:bg-gray-50 cursor-pointer transition-colors",
        get_indent_classes(@level)
      ]}>
        <div
          class="flex items-center flex-1"
          phx-click="nav_item_click"
          phx-value-action={@item["action"] || ""}
          phx-value-label={@item["label"]}
        >
          <%= if @item["icon"] do %>
            <.icon name={@item["icon"]} class="w-4 h-4 mr-3 text-gray-500" />
          <% end %>
          <span class="text-gray-900">{@item["label"]}</span>
        </div>

        <%= if @has_children do %>
          <button type="button" class="p-1 hover:bg-gray-100 rounded">
            <.icon name="hero-chevron-down" class="w-3 h-3 text-gray-400 transition-transform" />
          </button>
        <% end %>
      </div>
      
      <%= if @has_children do %>
        <div class="block">
          <%= for child <- @item["children"] do %>
            <.nav_item item={child} level={@level + 1} />
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  # Helper functions
  defp get_column_classes(columns) when is_list(columns), do: "grid-cols-12"
  defp get_column_classes(_), do: "grid-cols-1"

  defp get_gap_classes("xs"), do: "gap-1"
  defp get_gap_classes("sm"), do: "gap-2"
  defp get_gap_classes("md"), do: "gap-4"
  defp get_gap_classes("lg"), do: "gap-6"
  defp get_gap_classes("xl"), do: "gap-8"
  defp get_gap_classes(_), do: "gap-4"

  defp get_responsive_classes(true), do: "w-full"
  defp get_responsive_classes(_), do: ""

  defp get_column_width_classes("1/4"), do: "col-span-3"
  defp get_column_width_classes("1/3"), do: "col-span-4"
  defp get_column_width_classes("1/2"), do: "col-span-6"
  defp get_column_width_classes("2/3"), do: "col-span-8"
  defp get_column_width_classes("3/4"), do: "col-span-9"
  defp get_column_width_classes("full"), do: "col-span-12"
  defp get_column_width_classes(_), do: ""

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
end