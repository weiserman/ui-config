defmodule ConfigUi.ConfigValidator do
  @moduledoc """
  Validates JSON configuration for UI components.
  """

  @required_fields %{
    "form" => ["type", "components"],
    "container" => ["type", "components"],
    "navigation" => ["type", "items"],
    "columns" => ["type", "columns"],
    "text_input" => ["type", "name"],
    "email_input" => ["type", "name"],
    "select" => ["type", "name", "options"],
    "textarea" => ["type", "name"],
    "button" => ["type", "label"],
    "header" => ["type", "text"],
    "paragraph" => ["type", "text"]
  }

  @valid_component_types Map.keys(@required_fields)

  def validate_config(config) when is_map(config) do
    with :ok <- validate_type(config),
         :ok <- validate_required_fields(config),
         :ok <- validate_nested_components(config) do
      :ok
    end
  end

  def validate_config(_), do: {:error, "Configuration must be a map"}

  defp validate_type(%{"type" => type}) when type in @valid_component_types, do: :ok
  defp validate_type(%{"type" => type}), do: {:error, "Invalid component type: #{type}"}
  defp validate_type(_), do: {:error, "Missing required field: type"}

  defp validate_required_fields(%{"type" => type} = config) do
    required = Map.get(@required_fields, type, [])
    missing = Enum.filter(required, &(!Map.has_key?(config, &1)))

    case missing do
      [] -> :ok
      fields -> {:error, "Missing required fields: #{Enum.join(fields, ", ")}"}
    end
  end

  defp validate_nested_components(%{"components" => components}) when is_list(components) do
    Enum.reduce_while(components, :ok, fn component, _acc ->
      case validate_config(component) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_nested_components(%{"items" => items}) when is_list(items) do
    Enum.reduce_while(items, :ok, fn item, _acc ->
      case validate_nav_item(item) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp validate_nested_components(%{"columns" => columns}) when is_list(columns) do
    Enum.reduce_while(columns, :ok, fn column, _acc ->
      case Map.get(column, "component") do
        nil -> {:cont, :ok}
        component -> 
          case validate_config(component) do
            :ok -> {:cont, :ok}
            error -> {:halt, error}
          end
      end
    end)
  end

  defp validate_nested_components(_), do: :ok

  defp validate_nav_item(%{"label" => _label} = item) do
    case Map.get(item, "children") do
      children when is_list(children) ->
        Enum.reduce_while(children, :ok, fn child, _acc ->
          case validate_nav_item(child) do
            :ok -> {:cont, :ok}
            error -> {:halt, error}
          end
        end)
      _ -> :ok
    end
  end

  defp validate_nav_item(_), do: {:error, "Navigation item must have a label"}
end