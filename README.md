# [<img src="https://ipinfo.io/static/ipinfo-small.svg" alt="IPinfo" width="24"/>](https://ipinfo.io/) IPinfo Ruby Client Library

This is the official Ruby client library for the [IPinfo.io](https://ipinfo.io) IP address API, allowing you to look up your own IP address, or get any of the following details for an IP:
 - [IP geolocation data](https://ipinfo.io/ip-geolocation-api) (city, region, country, postal code, latitude, and longitude)
 - [ASN information](https://ipinfo.io/asn-api) (ISP or network operator, associated domain name, and type, such as business, hosting, or company)
 - [Firmographic data](https://ipinfo.io/ip-company-api) (the name and domain of the business that uses the IP address)
 - [Carrier details](https://ipinfo.io/ip-carrier-api) (the name of the mobile carrier and MNC and MCC for that carrier if the IP is used exclusively for mobile traffic)

Check all the data we have for your IP address [here](https://ipinfo.io/what-is-my-ip).

### Getting Started

You'll need an IPinfo API access token, which you can get by signing up for a free account at [https://ipinfo.io/signup](https://ipinfo.io/signup).

The free plan is limited to 50,000 requests per month, and doesn't include some of the data fields such as IP type and company data. To enable all the data fields and additional request volumes see [https://ipinfo.io/pricing](https://ipinfo.io/pricing)

⚠️ Note: This library does not currently support our newest free API https://ipinfo.io/lite. If you’d like to use IPinfo Lite, you can call the [endpoint directly](https://ipinfo.io/developers/responses#lite-api) using your preferred HTTP client. Developers are also welcome to contribute support for Lite by submitting a pull request.

#### Installation

Add this line to your application's Gemfile:

```ruby
gem 'IPinfo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install IPinfo

#### Quick Start

```ruby
require 'ipinfo'

access_token = '123456789abc'
handler = IPinfo::create(access_token)
ip_address = '216.239.36.21'

details = handler.details(ip_address)
details_v6 = handler.details_v6() # to get details from ipinfo's IPv6 host
city = details.city # Emeryville
loc = details.loc # 37.8342,-122.2900
```

##### Note about Rails 6+

If using this package in Rails 6+, the Zeitwerk auto-loader may not properly
recognize the gem due to its naming conventions (uppercased gem/module name).
See issue https://github.com/ipinfo/ruby/issues/24.

A workaround is to insert this in `application.rb`:

```ruby
require 'ipinfo' unless defined?(IPinfo)
```

#### Usage

The `IPinfo.details()` and `IPinfo.details_v6()` methods accept an IP address as an optional, positional
argument. If no IP address is specified, the API will return data for the IP
address from which it receives the request.

```ruby
require 'ipinfo'

access_token = '123456789abc'
handler = IPinfo::create(access_token)

details = handler.details()
details_v6 = handler.details_v6() # to get details from ipinfo's IPv6 host
city = details.city # "Emeryville"
loc = details.loc # 37.8342,-122.2900
```

#### Authentication

The IPinfo library can be authenticated with your IPinfo API token, which is
passed in as a positional argument. It also works without an authentication
token, but in a more limited capacity.

```ruby
access_token = '123456789abc'
handler = IPinfo::create(access_token)
```

#### Details Data

`handler.details()` and `handler.details_v6` will return a `Response` object that contains all fields
listed in the [IPinfo developerdocs](https://ipinfo.io/developers/responses#full-response)
with a few minor additions. Properties can be accessed directly.

```ruby
hostname = details.hostname # cpe-104-175-221-247.socal.res.rr.com
```

##### Country Name

`details.country_name` will return the country name, as defined by `DEFAULT_COUNTRY_LIST`
within `countriesData.rb`. See below for instructions on changing that file for use
with non-English languages. `details.country` will still return the country code.

```ruby
country = details.country # US
country_name = details.country_name # United States
```

##### European Union (EU) Country

`details.is_eu` will return `true` if the country is a member of the European Union (EU)
, as defined by `DEFAULT_EU_COUNTRIES_LIST` within `countriesData.rb`.

```ruby
is_eu = details.is_eu # false
```

It is possible to change the file by setting the `eu_countries` setting when creating the `IPinfo` object.

##### Country Flag

`details.country_flag` will return `emoji` and `unicode` of a country's flag, as defined by
`DEFAULT_COUNTRIES_FLAG_LIST` within `countriesData.rb`.

```ruby
country_flag = details.country_flag # {"emoji"=>"🇺🇸", "unicode"=>"U+1F1FA U+1F1F8"}
country_flag_emoji = details.country_flag['emoji'] # 🇺🇸
country_flag_unicode = details.country_flag['unicode'] # U+1F1FA U+1F1F8
```

##### Country Flag URL

`details.country_flag_url` will return a public link to the country's flag image as an SVG which can be used anywhere.

```ruby
country_flag = details.country_flag_url # {"https://cdn.ipinfo.io/static/images/countries-flags/US.svg"}
```

##### Country Currency

`details.country_currency` will return `code` and `symbol` of a country's currency, as defined by
`DEFAULT_COUNTRIES_CURRENCIES_LIST` within `countriesData.rb`.

```ruby
country_currency = details.country_currency # {"code"=>"USD", "symbol"=>"$"}
country_currency_code = details.country_currency['code'] # USD
country_currency_symbol = details.country_currency['symbol'] # $
```

It is possible to change the file by setting the `countries_currencies` setting when creating the `IPinfo` object.

##### Continent

`details.continent` will return `code` and `name` of the continent, as defined by
`DEFAULT_CONTINENT_LIST` within `countriesData.rb`.

```ruby
continent = details.continent # {"code"=>"NA", "name"=>"North America"}
continent_code = details.continent['code'] # NA
continent_name = details.continent['name'] # North America
```

It is possible to change the file by setting the `continents` setting when creating the `IPinfo` object.

#### IP Address

`details.ip_address` will return the `IPAddr` object from the
[Ruby Standard Library](https://ruby-doc.org/stdlib-2.5.1/libdoc/ipaddr/rdoc/IPAddr.html).
`details.ip` will still return a string.

```ruby
ip = details.ip # 104.175.221.247
ip_addr = details.ip_address # <IPAddr: IPv4:104.175.221.247/255.255.255.255>
```

##### Longitude and Latitude

`details.latitude` and `details.longitude` will return latitude and longitude,
respectively, as strings. `details.loc` will still return a composite string of
both values.

```ruby
loc = details.loc # 34.0293,-118.3570
lat = details.latitude # 34.0293
lon = details.longitude # -118.3570
```

##### Accessing all properties

`details.all` will return all details data as a dictionary.

```ruby
details.all = {
:asn => {  :asn => 'AS20001',
           :domain => 'twcable.com',
           :name => 'Time Warner Cable Internet LLC',
           :route => '104.172.0.0/14',
           :type => 'isp'},
:city => 'Los Angeles',
:company => {  :domain => 'twcable.com',
               :name => 'Time Warner Cable Internet LLC',
               :type => 'isp'},
:country => 'US',
:country_name => 'United States',
:hostname => 'cpe-104-175-221-247.socal.res.rr.com',
:ip => '104.175.221.247',
:ip_address => <IPAddr: IPv4:104.175.221.247/255.255.255.255>,
:loc => '34.0293,-118.3570',
:latitude => '34.0293',
:longitude => '-118.3570',
:phone => '323',
:postal => '90016',
:region => 'California'
}
```

#### Caching

In-memory caching of `details` data is provided by default via the
[`lru_redux`](https://github.com/SamSaffron/lru_redux) gem. This uses an LRU
(least recently used) cache with a TTL (time to live) by default. This means
that values will be cached for the specified duration; if the cache's max size
is reached, cache values will be invalidated as necessary, starting with the
oldest cached value.

##### Modifying cache options

Cache behavior can be modified by setting the `cache_options` keyword argument.
`cache_options` is a dictionary in which the keys are keyword arguments
specified in the `cachetools` library. The nesting of keyword arguments is to
prevent name collisions between this library and its dependencies.

* Default maximum cache size: 4096 (multiples of 2 are recommended to increase
  efficiency)
* Default TTL: 24 hours (in seconds)

```ruby
token = '1234'
handler = IPinfo::create(token, {:ttl => 30, :maxsize => 30})
```

##### Using a different cache

It's possible to use a custom cache by creating a child class of the
[CacheInterface](https://github.com/jhtimmins/ruby/blob/master/lib/ipinfo/cache/cache_interface.rb)
class and passing this into the handler object with the `cache` keyword
argument. FYI this is known as
[the Strategy Pattern](https://sourcemaking.com/design_patterns/strategy).

```ruby
handler = IPinfo.handler(token, {:cache => my_fancy_custom_class})
```

### Using a different HTTP library

Ruby is notorious for having lots of HTTP libraries. While `Net::HTTP` is a
reasonable default, you can set any other that
[Faradaysupports](https://github.com/lostisland/faraday/tree/29feeb92e3413d38ffc1fd3a3479bb48a0915730#faraday)
if you prefer.

```ruby
access_token = '123456789abc'
handler = IPinfo::create(access_token, {:http_client => my_client})
```

Don't forget to bundle the custom HTTP library as well.

#### Internationalization

When looking up an IP address, the response object includes a
`details.country_name` attribute which includes the country name based on
American English. It is possible to return the country name in other languages
by setting the `countries` setting when creating the `IPinfo` object.

```
{
 "BD" => "Bangladesh",
 "BE" => "Belgium",
 "BF" => "Burkina Faso",
 "BG" => "Bulgaria"
 ...
}
```

### Other Libraries

There are official IPinfo client libraries available for many languages including PHP, Go, Java, Ruby, and many popular frameworks such as Django, Rails, and Laravel. There are also many third-party libraries and integrations available for our API.

### About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier, VPN detection, hosted domains, and IP type data sets. Our API handles over 40 billion requests a month for 100,000 businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
