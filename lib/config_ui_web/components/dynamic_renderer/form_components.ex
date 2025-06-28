defmodule ConfigUiWeb.DynamicRenderer.FormComponents do
  use Phoenix.Component

  def text_input(assigns) do
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

  def email_input(assigns) do
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

  def select_input(assigns) do
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

  def textarea_input(assigns) do
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

  def button_component(assigns) do
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
end