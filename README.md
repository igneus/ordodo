# OrdoDO - *Ordo Divini Officii*

Generates an *ordo* (also known as [directory][wikipedia])
for a hierarchically organized set
of Roman Catholic liturgical calendars.

![OrdoDO logo](/img/or_dodo_logo.png)

## The problem

Every year, hundreds of Catholics around the world spend possibly
hundreds of hours each, compiling an *ordo*, a liturgical calendar
of their country, diocese or religious institute,
for the new liturgical year. Usually by hand.

*Ordo* is basically a combination of a set of closely related
liturgical calendars, e.g. calendars of dioceses of one country
or of houses of one province of some religious institute.

The task of compiling an *ordo* is extremely repetitive
and can be - completely or at least to a great extent -
automated. Let `ordodo` do the heavy lifting for you!

## Features

**Example output:**

* Ordo for dioceses of Czech Republic:
  - [2016/17](http://yakub.cz/ordo_2016/)
  - [2017/18](http://yakub.cz/ordo_2017/)
  - [2018/19](http://yakub.cz/ordo_2018/)

The current sample is a simple HTML page. Support for multiple
output formats will be added later, with special focus
on print-ready pdf output.

- [x] liturgical calendar computing
- [x] variants from proper calendars (with support for unlimited calendar levels)
- [ ] Gloria and Credo
- [ ] prefaces and the eucharistic prayer IV
- [ ] occasional parts of the Roman Canon
- [x] Divine Office hints (Vespers, Compline, Daytime Prayer)
- [ ] votive masses
- [ ] burial masses
- [ ] occasional blessings and other rites
- [ ] support for other date-related directions (often "International day of ..., should be mentioned in the universal prayer")

## Installation

is not really possible yet. But you can play with `ordodo`
nevertheless: install Ruby and Bundler, then clone `ordodo`
sources,

`bundle install`

in the project's root directory to install dependencies
and then execute `ordodo` like

`bundle exec ruby -Ilib bin/ordodo ...`

## Basic usage

`$ ordodo myconfig.xml`

generates ordo according to configuration in `myconfig.xml`
for the upcoming liturgical year. Definitely the most common
task you will use `ordodo` for.

Output is by default produced in directory `ordo_YEAR`,
created in the current working directory.

`$ ordodo myconfig.xml 2050`

generates ordo for the year specified (which, of course, knows
nothing about calendar updates which will probably happen
in the meantime).

In the `examples/` directory you can find a few example
configurations to start with.

## Configuration

`ordodo`'s main user interface is it's configuration file.

**Philosophy behind it:**
*ordo* is prepared only once a year, and it's content is "mostly
the same". As a user you don't want to remember anything about
`ordodo` - this program used once a year - and it's controls and
settings. You want to set it up once
(or have someone set it up for you) - and then it should, if possible,
just work forever. Once a year you run `ordodo`
with the configuration from the last year, check that the output
is correct, send it to print. All done.

See `examples/czech_republic.xml` for a complete and commented
configuration of an *ordo* for Czech dioceses.
It uses most features currently available, and mentions
those which are not used.

### Preparing calendar data

For calendar computations `ordodo` relies on
[calendarium-romanum][caro]. It also expects calendar data
in it's [data format][caro_data].

### Customization of translation strings and output templates

## License

MIT

## Credits

`ordodo` logo incorporates
a [drawing of a dodo][dodo_img_source]
by Pearson Scott Foresman. The drawing is in public domain.

[dodo_img_source]: https://commons.wikimedia.org/wiki/Raphus_cucullatus#/media/File:Dodo_2_(PSF).png
[wikipedia]: https://en.wikipedia.org/wiki/Directorium
[caro]: http://github.com/igneus/calendarium-romanum
[caro_data]: https://github.com/igneus/calendarium-romanum/tree/master/data
