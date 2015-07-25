# Redshift #
## Description ##
Open source clone of flux

From redshift(1):

redshift  adjusts the color temperature of your screen according to your surroundings. This may help your eyes hurt less if you are working
in front of the screen at night.

The color temperature is set according to the position of the sun. A different color temperature is set during night  and  daytime.  During
twilight  and  early  morning,  the  color  temperature transitions smoothly from night to daytime temperature to allow your eyes to slowly
adapt.

## Usage ##
Add the following to your manifest and customize your GPS coordinates:
```ruby
class {'redshift':
  lat => 48.1,
  lon => 11.6,
}
```
