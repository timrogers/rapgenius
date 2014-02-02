# rapgenius.rb

![Rap Genius logo](http://f.cl.ly/items/303W0c1i2r100j2u3Y0y/Screen%20Shot%202013-08-17%20at%2016.01.19.png)

## What does this do?

It's a Ruby gem for accessing lyrics, artists and explanations on
[Rap Genius](http://rapgenius.com).

In pre-1.0.0 versions, this gem used Nokogiri to scrape Rap Genius's pages,
but no more. The new [Genius iOS app](http://rapgenius.com/static/app) uses
a private API, which this gem makes use of.

## Installation

Install the gem, and you're ready to go. Simply add the following to your
Gemfile:

`gem "rapgenius", "~> 1.0.0"`

## Usage

__The best way to get a decent idea of the attributes available on `Song` and
the other objects is by looking through the files in `lib/rapgenius`.__

### Searching

You can search for songs by various fields. All of these
methods return an array of `Song` objects...:

```ruby
RapGenius.search("Versace")
RapGenius.search_by_title("Versace")
RapGenius.search_by_artist("Migos")
RapGenius.search_by_lyrics("medusa")
```

If more than 20 results are returned, you won't be able to get access to
records beyond the 20th. There doesn't appear to be any pagination support
in the API.

### Songs

Songs on Rap Genius have unique identifiers. They're not especially
easy to find, but if you hover over the "pyong" button near the top of the page,
you'll see the song's ID in the URL. Once you have an ID, you can load a
song via the API:

```ruby
require 'rapgenius'

song = RapGenius::Song.find(176872)
song.title # => "Versace"
song.artists.map(&:name) # => ["Migos", "Drake", "Zaytoven"]
```

Once you've found the song you're seeking, there's plenty of other useful
details you can access:

```ruby
song.title
# => "Versace"

song.url
# => "http://rapgenius.com/Migos-versace-lyrics""

song.pyongs
# => 22

song.description
# => "Released in June 2013, not only did they take the beat from Soulja Boy’s OMG part 2 but they absolutely killed it."
```


### Lines

Once you've got a song, you can then go through its "lines", which includes
annotated and unannotated parts of the content.

```ruby
line = song.lines[1]

line.lyric
# => Versace, Versace, Medusa head on me like I'm 'luminati

line.annotations
# => ["Read about how this collaboration came to pass here..."]

line.song
# => #<RapGenius::Song:0x007fccdba50a50 @id=176872...
```

### Media

Rap Genius provides great access to media like MP3s on Soundcloud or videos
on YouTube direct from songs.

```ruby
media = song.media.first

media.type
# => "audio"

media.provider
# => "soundcloud"

media.url
# => "https://soundcloud.com/mixtapemechaniks/migos-ft-drake-versace-remix"
```

### Artist

You can navigate from a song to its artist, and then to other songs by that
artist. Magic, huh?!

```ruby
artist = song.artist # or song.artists, song.featured_artists or song.producer_artists

artist.name
# => "Migos"

artist.type
# => :primary

artist.url
# => "http://rapgenius.com/artists/Migos"

artist.description
# => "Migos are an American hip-hop group from Atlanta, Georgia..."

artist.songs
# => [#<RapGenius::Song:0x007fccdb884398...]

# Songs for an artist load in pages of 25
artist.songs(page: 2)
# => [#<RapGenius::Song:0x007fccdb884398...]
```

## Examples

I've built a game called "Guess The Track" using the gem - find out more, grab
the source or play for yourself [here](https://github.com/timrogers/rapgenius/blob/master/examples/guess_the_track.md).

## Contributing

If you'd like to contribute anything else, go ahead or better still, make an issue and we can talk it over and spec it out! A few quick tips:

* Don't update the version numbers before your pull request - I'll sort that part out for you.
* Make sure you write specs, then run them with `$ bundle exec rake`
* Update this README.md file so I, and users, know how your changes work

## Copyright

Copyright (c) 2013-2014 Tim Rogers. See LICENSE for details.

## Get in touch

[timrogers](https://github.com/timrogers) and [tsigo](https://github.com/tsigo) are the gem's primary contributors.

Any questions, thoughts or comments? Email me at <me@timrogers.co.uk> or create an issue.
