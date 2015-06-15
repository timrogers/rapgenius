# rapgenius

![Rap Genius logo](http://assets.rapgenius.com/images/apple-touch-icon.png?1432674944)

## What does this do?

It's a Ruby gem for accessing songs, artists and annotations on
[Genius](http://genius.com).

## Installation

Install the gem, and you're ready to go. Simply add the following to your
Gemfile:

```ruby
gem "rapgenius", "~> 1.1.1"
```

## Usage

The best way to get a decent idea of the attributes available on `Song` and
the other objects is by checking out the API documentation at:
https://docs.genius.com

### Authenticating

You can create a client and grab an access token from
<http://genius.com/api-clients>.

From there, you can also generate a client access token and use it like so:

``` ruby
RapGenius::Client.access_token = 'your-access-token'
```

You'll need to have set your token in order to be able to make requests.

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

Songs on Genius have unique identifiers. They're not especially
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

Copyright (c) 2013-2015 Tim Rogers. See LICENSE for details.

## Get in touch

Any questions, thoughts or comments? Email me at <me@timrogers.co.uk> or create an issue.
