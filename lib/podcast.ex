defmodule Podcast do
  @moduledoc """
  Podcast keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  Application.ensure_all_started(:inets)
  Application.ensure_all_started(:ssl)

  def get_xml do
    feed_url = 'https://feed.podbean.com/wellthatdidntwork/feed.xml'
    IO.puts feed_url
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, {feed_url, []}, [], [])
    # IO.puts body
    # File.write('C:\\Users\\brett_\\Documents\\projects\\elixir\\podcastOld\\stuff.txt', body, [:write])
    body
  end

  defp print_episode_info(info) do
      "Title: #{Enum.at(info, 1)}. Duration: #{Enum.at(info, 3)}. Episode: #{Enum.at(info, 4)}. Url: #{Enum.at(info, 2)}."
  end

  # get xml
  # parse xml
      # item
          # title
          # pubDate
          # enclosure
          # itunes:duration
          # itunes:episode 
  def parse_xml(xml) do
      item_regex = ~r/.*<item>.*<title>(?<title>.*)<\/title>.*<enclosure url="(?<url>.*)".*\/>.*<itunes:duration>(?<duration>.*)<\/itunes:duration>.*<itunes:episode>(?<episode>.*)<\/itunes:episode>.*<\/item>.*/Usi
      _captures = Regex.named_captures(item_regex, to_string(xml))
      # File.write('C:\\Users\\brett_\\Documents\\projects\\elixir\\podcast\\feed.txt', xml)
      # IO.puts Regex.match?(item_regex, to_string(xml))
      # IO.puts "Title: #{captures["title"]}. Duration: #{captures["duration"]}. Episode: #{captures["episode"]}."
      Regex.scan(item_regex, to_string(xml), [:all_names]) |> Enum.map(&get_objs/1)  #|> Enum.map(&hd/1)
      # text = Enum.map(scan, &print_episode_info/1)
      # IO.inspect scan 
      # Enum.each(scan, (fn x -> IO.puts x end))
  end

  defp get_objs(obj) do
      [title: Enum.at(obj, 1), url: Enum.at(obj, 2), duration: Enum.at(obj, 3), episode: Enum.at(obj, 4)]
  end
end
