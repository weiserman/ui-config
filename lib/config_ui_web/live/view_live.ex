defmodule ConfigUiWeb.ViewLive do
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

  def mount(params, _session, socket) do
    template_key = params["template"] || "contact_form"
    selected_config = Map.get(@sample_templates, template_key, @sample_templates["contact_form"])

    {:ok,
     socket
     |> assign(:selected_template, template_key)
     |> assign(:config, selected_config)
     |> assign(:event_message, nil)}
  end

  def handle_event("select_template", %{"template" => template_key}, socket) do
    case Map.get(@sample_templates, template_key) do
      nil ->
        {:noreply, socket}

      template_config ->
        {:noreply,
         socket
         |> assign(:selected_template, template_key)
         |> assign(:config, template_config)}
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
