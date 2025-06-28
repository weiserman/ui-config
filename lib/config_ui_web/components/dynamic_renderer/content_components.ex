defmodule ConfigUiWeb.DynamicRenderer.ContentComponents do
  use Phoenix.Component

  def header_component(assigns) do
    assigns = assign(assigns, :level, assigns.config["level"] || 1)

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

  def paragraph_component(assigns) do
    ~H"""
    <p class="text-gray-700 mb-4">{@config["text"] || "Paragraph text"}</p>
    """
  end

  def unknown_component(assigns) do
    ~H"""
    <div class="p-3 bg-red-50 border border-red-200 rounded-md">
      <p class="text-sm text-red-800">
        Unknown component type: {inspect(@config["type"])}
      </p>
    </div>
    """
  end
end