# rapgenius

![Rap Genius logo](http://f.cl.ly/items/303W0c1i2r100j2u3Y0y/Screen%20Shot%202013-08-17%20at%2016.01.19.png)

## What does this do?

It's a Ruby gem for accessing lyrics and explanations on
[Rap Genius](http://rapgenius.com). 

They very sadly [don't have an API](https://twitter.com/RapGenius/status/245057326321655808) so I decided to replicate one for myself
with a nice bit of screen scraping with [Nokogiri](https://github.com/sparklemotion/nokogiri), much like my [amex](https://github.com/timrogers/amex), [ucas](https://github.com/timrogers/ucas) and [lloydstsb](https://github.com/timrogers/lloydstsb) gems.

## Installation

Install the gem, and you're ready to go. Simply add the following to your
Gemfile:

`gem "rapgenius", "~> 0.0.2"`

## Usage

Songs on Rap Genius don't have numeric identifiers as far as I can tell - they're identified by a URL slug featuring the artist and song name, for instance "Big-sean-control-lyrics". We use this to fetch a particular track, like so:

```ruby
require 'rapgenius'
song = RapGenius::Song.find("Big-sean-control-lyrics")
```

Once you've got the song, you can easily load details about it. This uses
Nokogiri to fetch the song's page and then parse it:

```ruby
song.title
# => "Control"

song.artist
# => "Big Sean"

song.full_artist
# => "Big Sean (Ft. Jay Electronica & Kendrick Lamar)"

song.images
# => ["http://s3.amazonaws.com/rapgenius/1376434983_jay-electronica.jpg", "http://s3.amazonaws.com/rapgenius/1375029260_Big%20Sean.png", "http://s3.amazonaws.com/rapgenius/Kendrick-Lamar-1024x680.jpg"]

song.description
# => "The non-album cut from Sean that basically blew up the Internet due to a world-beating verse by Kendrick Lamar...
```

The `#annotations` accessor on a Song returns an array of RapGenius::Annotation
objects corresponding to different annotated lines of the song, identified by
their `id`.

You can look these up manually using `RapGenius::Annotation.find("id")`. You
can grab the ID for a lyric from a RapGenius page by right clicking on an annotation, copying the shortcut and then finding the number after "http://rapgenius.com".

```ruby
song.annotations
# => [<RapGenius::Annotation>, <RapGenius::Annotation>...]

annotation = song.annotations[99]

annotation.lyric
# => "And that goes for Jermaine Cole, Big KRIT, Wale\nPusha T, Meek Millz, A$AP Rocky, Drake\nBig Sean, Jay Electron', Tyler, Mac Miller"

annotation.explanation
# => "Kendrick calls out some of the biggest names in present day Hip-hop...""

annotation.song == song # You can get back to the song from the annotation...
# => true

annotation.id
# => "2093001"

annotation2 = RapGenius::Annotation.find("2093001") # Fetching directly...

annotation == annotations2
# => true
```

## Contributing

There are a few things I'd love to see added to this gem:

* __Searching__ - having to know the path to a particular track's lyrics isn't super intuitive
* __Support for *\*Genius*__ - RapG enius also have other sites on subdomains like [News Genius](http://news.rapgenius.com) and [Poetry Genius](http://poetry.rapgenius.com). These could very easily be supported, since theyre identical in terms of markup.

This gem is open source, so feel free to add anything you want, then make a pull request. A few quick tips:

* Don't update the version numbers before your pull request - I'll sort that part out for you!
* Make sure you write specs, then run them with `$ bundle exec rake`
* Update this README.md file so I, and users, know how your changes work

## Get in touch

Any questions, thoughts or comments? Email me at <me@timrogers.co.uk>.