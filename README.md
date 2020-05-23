# [<img src="https://ipinfo.io/static/ipinfo-small.svg" alt="IPinfo" width="24"/>](https://ipinfo.io/) IPinfo Ruby Client Library

This is the official Ruby client library for the [IPinfo.io](https://ipinfo.io) IP address API, allowing you to lookup your own IP address, or get any of the following details for an IP:
 - IP geolocation (city, region, country, postal code, latitude and longitude)
 - ASN details (ISP or network operator, associated domain name, and type, such as business, hosting or company)
 - Company details (the name and domain of the business that uses the IP address)
 - Carrier details (the name of the mobile carrier and MNC and MCC for that carrier if the IP is used exclusively for mobile traffic)


### Getting Started

You'll need an IPinfo API access token, which you can get by singing up for a free account at [https://ipinfo.io/signup](https://ipinfo.io/signup?ref=lib-Ruby).

The free plan is limited to 50,000 requests per month, and doesn't include some of the data fields such as IP type and company data. To enable all the data fields and additional request volumes see [https://ipinfo.io/pricing](https://ipinfo.io/pricing?ref=lib-Ruby)

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
require 'IPinfo'

access_token = '123456789abc'
handler = IPinfo::create(access_token)
ip_address = '216.239.36.21'

details = handler.details(ip_address)
city = details.city # Emeryville
loc = details.loc # 37.8342,-122.2900
```

#### Usage

The `IPinfo.details()` method accepts an IP address as an optional, positional argument. If no IP address is specified, the API will return data for the IP address from which it receives the request.

```ruby
require 'IPinfo'

access_token = '123456789abc'
handler = IPinfo::create(access_token)

details = handler.details()
city = details.city # "Emeryville"
loc = details.loc # 37.8342,-122.2900
```

#### Authentication

The IPinfo library can be authenticated with your IPinfo API token, which is passed in as a positional argument. It also works without an authentication token, but in a more limited capacity.

```ruby
access_token = '123456789abc'
handler = IPinfo::create(access_token)
```

#### Details Data

`handler.details()` will return a `Response` object that contains all fields listed in the [IPinfo developer docs](https://ipinfo.io/developers/responses#full-response) with a few minor additions. Properties can be accessed directly.

```ruby
hostname = details.hostname # cpe-104-175-221-247.socal.res.rr.com
```

##### Country Name

`details.country_name` will return the country name, as supplied by the `countries.json` file. See below for instructions on changing that file for use with non-English languages. `details.country` will still return country code.

```ruby
country = details.country # US
country_name = details.country_name # United States
```

#### IP Address

`details.ip_address` will return the an `IPAddr` object from the [Ruby Standard Library](https://ruby-doc.org/stdlib-2.5.1/libdoc/ipaddr/rdoc/IPAddr.html). `details.ip` will still return a string.

```ruby
ip = details.ip # 104.175.221.247
ip_addr = details.ip_address # <IPAddr: IPv4:104.175.221.247/255.255.255.255>
```

##### Longitude and Latitude

`details.latitude` and `details.longitude` will return latitude and longitude, respectively, as strings. `details.loc` will still return a composite string of both values.

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

In-memory caching of `details` data is provided by default via the [lru_redux](https://github.com/SamSaffron/lru_redux) gem. This uses an LRU (least recently used) cache with a TTL (time to live) by default. This means that values will be cached for the specified duration; if the cache's max size is reached, cache values will be invalidated as necessary, starting with the oldest cached value.

##### Modifying cache options

Cache behavior can be modified by setting the `cache_options` keyword argument. `cache_options` is a dictionary in which the keys are keyword arguments specified in the `cachetools` library. The nesting of keyword arguments is to prevent name collisions between this library and its dependencies.

* Default maximum cache size: 4096 (multiples of 2 are recommended to increase efficiency)
* Default TTL: 24 hours (in seconds)

```ruby
token = '1234'
handler = IPinfo::create(token, {:ttl => 30, :maxsize => 30})
```

##### Using a different cache

It's possible to use a custom cache by creating a child class of the [CacheInterface](https://github.com/jhtimmins/ruby/blob/master/lib/ipinfo/cache/cache_interface.rb) class and passing this into the handler object with the `cache` keyword argument. FYI this is known as [the Strategy Pattern](https://sourcemaking.com/design_patterns/strategy).

```ruby
handler = IPinfo.handler(token, {:cache => my_fancy_custom_class})
```


### Using a different HTTP library
Ruby is notorious for having lots of HTTP libraries. While `Net::HTTP` is a reasonable default, you can set any other that [Faraday supports](https://github.com/lostisland/faraday/tree/29feeb92e3413d38ffc1fd3a3479bb48a0915730#faraday) if you prefer.

```ruby
access_token = '123456789abc'
handler = IPinfo::create(access_token, {:http_client => my_client})
```

Don't forget to bundle the custom HTTP library as well.

#### Internationalization

When looking up an IP address, the response object includes a `details.country_name` attribute which includes the country name based on American English. It is possible to return the country name in other languages by setting the `countries` setting when creating the `IPinfo` object.

The file must be a `.json` file with the following structure:

```
{
 "BD": "Bangladesh",
 "BE": "Belgium",
 "BF": "Burkina Faso",
 "BG": "Bulgaria"
 ...
}
```

### Other Libraries

There are official IPinfo client libraries available for many languages including PHP, Go, Java, Ruby, and many popular frameworks such as Django, Rails and Laravel. There are also many third party libraries and integrations available for our API.

### About IPinfo

Founded in 2013, IPinfo prides itself on being the most reliable, accurate, and in-depth source of IP address data available anywhere. We process terabytes of data to produce our custom IP geolocation, company, carrier and IP type data sets. Our API handles over 12 billion requests a month for 100,000 businesses and developers.

[![image](https://avatars3.githubusercontent.com/u/15721521?s=128&u=7bb7dde5c4991335fb234e68a30971944abc6bf3&v=4)](https://ipinfo.io/)
