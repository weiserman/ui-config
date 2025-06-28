defmodule ConfigUiWeb.EventMessage do
  use Phoenix.Component

  attr :message, :string, default: nil
  attr :class, :string, default: ""

  def event_message(assigns) do
    ~H"""
    <%= if @message do %>
      <div class={["bg-green-50 border border-green-200 rounded-md p-3 mx-4 mt-3", @class]}>
        <div class="flex justify-between items-center">
          <p class="text-sm text-green-800">{@message}</p>
          <button phx-click="clear_message" class="text-green-600 hover:text-green-800">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </div>
      </div>
    <% end %>
    """
  end
end