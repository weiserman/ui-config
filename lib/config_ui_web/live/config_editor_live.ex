defmodule ConfigUiWeb.ConfigEditorLive do
  use ConfigUiWeb, :live_view
  alias ConfigUiWeb.DynamicRenderer

  @sample_templates %{
    "contact_form" => %{
      "type" => "form",
      "title" => "Contact Form",
      "components" => [
        %{
          "type" => "text_input",
          "label" => "Full Name",
          "name" => "name",
          "required" => true
        },
        %{
          "type" => "email_input",
          "label" => "Email Address",
          "name" => "email",
          "required" => true
        },
        %{
          "type" => "textarea",
          "label" => "Message",
          "name" => "message",
          "rows" => 4
        },
        %{
          "type" => "button",
          "label" => "Send Message",
          "action" => "submit"
        }
      ]
    },
    "user_profile" => %{
      "type" => "form",
      "title" => "User Profile",
      "components" => [
        %{
          "type" => "text_input",
          "label" => "Username",
          "name" => "username",
          "required" => true
        },
        %{
          "type" => "email_input",
          "label" => "Email",
          "name" => "email",
          "required" => true
        },
        %{
          "type" => "select",
          "label" => "Role",
          "name" => "role",
          "options" => ["Admin", "User", "Guest"]
        },
        %{
          "type" => "textarea",
          "label" => "Bio",
          "name" => "bio",
          "rows" => 3
        },
        %{
          "type" => "button",
          "label" => "Save Profile",
          "action" => "submit"
        }
      ]
    },
    "dashboard" => %{
      "type" => "container",
      "title" => "Dashboard",
      "components" => [
        %{
          "type" => "header",
          "text" => "Welcome to Your Dashboard",
          "level" => 1
        },
        %{
          "type" => "paragraph",
          "text" => "Here's an overview of your recent activity and key metrics."
        },
        %{
          "type" => "container",
          "components" => [
            %{
              "type" => "header",
              "text" => "Quick Actions",
              "level" => 2
            },
            %{
              "type" => "button",
              "label" => "Create New Project",
              "action" => "create_project"
            },
            %{
              "type" => "button",
              "label" => "View Reports",
              "action" => "view_reports"
            }
          ]
        }
      ]
    },
    "navigation" => %{
      "type" => "navigation",
      "title" => "Main Navigation",
      "items" => [
        %{
          "label" => "Dashboard",
          "icon" => "hero-home",
          "action" => "navigate_dashboard"
        },
        %{
          "label" => "Projects",
          "icon" => "hero-folder",
          "children" => [
            %{
              "label" => "Web Development",
              "action" => "navigate_web_projects",
              "children" => [
                %{
                  "label" => "React Apps",
                  "action" => "navigate_react"
                },
                %{
                  "label" => "Vue.js Apps",
                  "action" => "navigate_vue"
                }
              ]
            },
            %{
              "label" => "Mobile Apps",
              "action" => "navigate_mobile_projects"
            },
            %{
              "label" => "Desktop Apps",
              "action" => "navigate_desktop_projects"
            }
          ]
        },
        %{
          "label" => "Team",
          "icon" => "hero-users",
          "children" => [
            %{
              "label" => "Members",
              "action" => "navigate_team_members"
            },
            %{
              "label" => "Roles & Permissions",
              "action" => "navigate_team_roles"
            }
          ]
        },
        %{
          "label" => "Settings",
          "icon" => "hero-cog-6-tooth",
          "action" => "navigate_settings"
        },
        %{
          "label" => "Help & Support",
          "icon" => "hero-question-mark-circle",
          "action" => "navigate_help"
        }
      ]
    },
    "columns" => %{
      "type" => "columns",
      "gap" => "lg",
      "responsive" => true,
      "columns" => [
        %{
          "width" => "1/3",
          "component" => %{
            "type" => "navigation",
            "title" => "Sidebar Navigation",
            "items" => [
              %{
                "label" => "Dashboard",
                "icon" => "hero-home",
                "action" => "navigate_dashboard"
              },
              %{
                "label" => "Forms",
                "icon" => "hero-document-text",
                "action" => "navigate_forms"
              },
              %{
                "label" => "Settings",
                "icon" => "hero-cog-6-tooth",
                "children" => [
                  %{
                    "label" => "Profile",
                    "action" => "navigate_profile"
                  },
                  %{
                    "label" => "Preferences",
                    "action" => "navigate_preferences"
                  }
                ]
              }
            ]
          }
        },
        %{
          "width" => "2/3",
          "component" => %{
            "type" => "form",
            "title" => "Main Content Area",
            "components" => [
              %{
                "type" => "header",
                "text" => "User Registration",
                "level" => 2
              },
              %{
                "type" => "text_input",
                "label" => "Full Name",
                "name" => "name",
                "required" => true
              },
              %{
                "type" => "email_input",
                "label" => "Email Address",
                "name" => "email",
                "required" => true
              },
              %{
                "type" => "select",
                "label" => "Department",
                "name" => "department",
                "options" => ["Engineering", "Design", "Marketing", "Sales"]
              },
              %{
                "type" => "textarea",
                "label" => "Additional Notes",
                "name" => "notes",
                "rows" => 3
              },
              %{
                "type" => "button",
                "label" => "Create Account",
                "action" => "submit"
              }
            ]
          }
        }
      ]
    }
  }

  def mount(_params, _session, socket) do
    default_config = @sample_templates["contact_form"]

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
    case Map.get(@sample_templates, template_key) do
      nil ->
        {:noreply, socket}

      template_config ->
        {:noreply,
         socket
         |> assign(:config_json, Jason.encode!(template_config, pretty: true))
         |> assign(:parsed_config, template_config)
         |> assign(:selected_template, template_key)
         |> assign(:json_error, nil)}
    end
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
    {:noreply, assign(socket, :event_message, "Form submitted successfully!")}
  end

  def handle_event("button_click", %{"action" => action}, socket) do
    {:noreply, assign(socket, :event_message, "Event fired: #{action}")}
  end

  def handle_event("nav_item_click", %{"action" => action, "label" => label}, socket) do
    {:noreply, assign(socket, :event_message, "Navigation clicked: #{label} (#{action})")}
  end

  def handle_event("clear_message", _params, socket) do
    {:noreply, assign(socket, :event_message, nil)}
  end
end
