defmodule ConfigUiWeb.DynamicRenderer do
  use Phoenix.Component
  
  alias ConfigUiWeb.DynamicRenderer.{
    FormComponents,
    LayoutComponents,
    ContentComponents
  }

  def render(assigns) do
    ~H"""
    <div class={if @config["type"] == "columns", do: "w-full", else: "max-w-md mx-auto"}>
      <.render_component config={@config} />
    </div>
    """
  end

  defp render_component(%{config: %{"type" => "columns"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <LayoutComponents.columns_layout config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "form"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <LayoutComponents.form_layout config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "container"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <LayoutComponents.container_layout config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "navigation"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <LayoutComponents.navigation_layout config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "text_input"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <FormComponents.text_input config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "email_input"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <FormComponents.email_input config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "select"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <FormComponents.select_input config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "textarea"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <FormComponents.textarea_input config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "button"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <FormComponents.button_component config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "header"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <ContentComponents.header_component config={@config} />
    """
  end

  defp render_component(%{config: %{"type" => "paragraph"} = config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <ContentComponents.paragraph_component config={@config} />
    """
  end

  defp render_component(%{config: config} = assigns) do
    assigns = assign(assigns, :config, config)
    ~H"""
    <ContentComponents.unknown_component config={@config} />
    """
  end
end