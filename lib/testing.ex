defmodule Testing do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    def get_xml do
        feed_url = 'https://feed.podbean.com/wellthatdidntwork/feed.xml'
        # IO.puts feed_url
        {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request feed_url
        body
    end

    defp print_episode_info(info) do
        "Title: #{Enum.at(info, 1)}. Duration: #{Enum.at(info, 2)}. Episode: #{Enum.at(info, 3)}."
    end

    # get xml
    # parse xml
        # item
            # title
            # pubDate
            # enclosure
            # itunes:duration
            # itunes:episode 
    def parseXml do
        xml = get_xml()
        item_regex = ~r/.*<item>.*<title>(?<title>.*)<\/title>.*<itunes:duration>(?<duration>.*)<\/itunes:duration>.*<itunes:episode>(?<episode>.*)<\/itunes:episode>.*<\/item>.*/Usi
        _captures = Regex.named_captures(item_regex, to_string(xml))
        # File.write('C:\\Users\\brett_\\Documents\\projects\\elixir\\podcast\\feed.txt', xml)
        # IO.puts Regex.match?(item_regex, to_string(xml))
        # IO.puts "Title: #{captures["title"]}. Duration: #{captures["duration"]}. Episode: #{captures["episode"]}."
        scan = Regex.scan(item_regex, to_string(xml), [:all_names]) |> Enum.map(&print_episode_info/1)  #|> Enum.map(&hd/1)
        # text = Enum.map(scan, &print_episode_info/1)
        # IO.inspect scan 
        Enum.each(scan, (fn x -> IO.puts x end))
    end
end

Testing.parseXml