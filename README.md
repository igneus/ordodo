# OrdoDO - *Ordo Divini Officii*

Generates an *ordo* for a structured set of Roman Catholic liturgical
calendars.

![OrdoDO logo](/img/or_dodo_logo.png)

## The problem

Every year, hundreds of Catholics around the world spend
hundreds of hours each, compiling an *ordo*, a liturgical calendar,
for the new liturgical year. Usually by hand.

*Ordo* is basically a combination of a set of closely related
liturgical calendars, e.g. calendars of dioceses of one country
or of houses of one province of some religious institute.

The task of compiling an *ordo* is extremely repetitive
and can be - completely or at least to a great extent -
automated. Let `ordodo` do the heavy lifting for you!

## Installation

## Basic usage

`$ ordodo myconfig.xml`

generates ordo according to configuration in myconfig.xml
for the upcoming liturgical year. Definitely the most common
task you will use `ordodo` for.

Output is by default produced in directory `ordo_YEAR`,
created in the current working directory.

`$ ordodo myconfig.xml 2050`

generates ordo for the year specified (which, of course, knows
nothing about calendar updates which will probably happen
in the meantime).

## Configuration

### Localization

### Preparing calendar data

### Customization of translation strings and output templates

## License

## Author
