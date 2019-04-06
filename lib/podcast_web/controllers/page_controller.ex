defmodule PodcastWeb.PageController do
  use PodcastWeb, :controller

  def index(conn, _params) do
    xml = Podcast.get_xml
    objs = Podcast.parse_xml xml
    render(conn, "index.html", [text: "Some hopeful text?", other: "More text?", xml: xml, objs: Enum.take(objs, 10)])
  end
end
