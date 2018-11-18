defmodule HasbihalWeb.Api.V1.FileView do
  use HasbihalWeb, :view
  alias HasbihalWeb.Api.V1.FileView

  def render("index.json", %{files: files}) do
    %{data: render_many(files, FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id, file: file.file}
  end
end
