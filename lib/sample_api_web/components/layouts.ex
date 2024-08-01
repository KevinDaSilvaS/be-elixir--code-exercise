defmodule SampleApiWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use SampleApiWeb, :controller` and
  `use SampleApiWeb, :live_view`.
  """
  use SampleApiWeb, :html

  embed_templates "layouts/*"
end
