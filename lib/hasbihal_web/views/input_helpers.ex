defmodule HasbihalWeb.InputHelpers do
  @moduledoc false

  use Phoenix.HTML
  alias Phoenix.HTML.Form

  def input(form, field, opts \\ []) do
    type = opts[:using] || Form.input_type(form, field)

    wrapper_opts = [
      class:
        "mdl-textfield mdl-js-textfield mdl-textfield--floating-label #{state_class(form, field)}"
    ]

    label_opts = [class: "mdl-textfield__label"]
    input_opts = [class: "mdl-textfield__input"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      error = HasbihalWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !Map.get(form.source, :action) -> ""
      form.errors[field] -> "is-invalid is-dirty"
      true -> ""
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Form, type, [form, field, input_opts])
  end
end
