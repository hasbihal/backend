defmodule Hasbihal.Email do
  @moduledoc false
  use Bamboo.Phoenix, view: HasbihalWeb.EmailView

  def confirmation_mail(email_address) do
    new_email()
    |> to(email_address)
    |> from("noreply@hasbihal.com")
    |> subject("Welcome!")
    |> put_html_layout({HasbihalWeb.LayoutView, "email.html"})
    |> render("confirmation.html")
  end
end
