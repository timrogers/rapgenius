# Changelog

__v0.0.1__ (17th August 2013)

* Initial version

__v0.0.2__ (17th August 2013)

* Adds `RapGenius::Song.find` to replicate behaviour in `RapGenius::Annotation`

__v0.0.3__ (22nd August 2013, *contributed by [tsigo](https://github.com/tsigo)*)

* Improves implementation of HTTParty
* Reorganises specs to use VCR

__v0.1.0__ (29th August 2013, *contributed by [tsigo](https://github.com/tsigo)*)

* Adds support for searching for songs with `RapGenius::Song.search("Song, artist name or other query")`

__v1.0.0__ (27th January 2014)

* Switches to using the private REST API used by the soon to be released
[Genius iOS app](http://rapgenius.com/static/app).
* Vastly improves quality of data available on songs and their lyrics
* Provides access to media items and song artists

__v1.0.1__ (1st February 2014)

* Allows pagination through an artist's songs

__v1.0.2__ (2nd February 2014)

* Defines a specific `RapGenius::NotFoundError` for when requests to the API
return a 404

__v1.0.4__ (8th November 2014)

* Fix annotations, so they're combined into a string with a space between each
one