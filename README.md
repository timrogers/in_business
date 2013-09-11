# in_business

Working with business opening times is pretty hard, or at least, a lot of effort
to write for each application. 

We have awesome gems like
[business_time](https://github.com/bokmann/business_time) which help, but there's
a gap in the market for something that knows your hours, and can quickly tell
you whether a particular time is open or closed concretely. As fun as crazy
time calculations are!

I've been doing quite a lot of work recently building [Twilio](http://www.twilio.com)
apps (such as my startup employer [GoCardless](https://gocardless.com)'s
[Nodephone](https://gocardless.com/blog/data-driven-support/), amongst others) where you need
to work out if an incoming call is during office hours or not.

This gem allows you to do that kind of thing with simple `.open?` and `.closed?`
methods, and even supports holidays!

*in_business* depends on Rails's [ActiveSupport](https://github.com/rails/rails/tree/master/activesupport)
and is awesome combined with the [holidays](https://github.com/alexdunae/holidays)
gem.

## Usage

```ruby
InBusiness.open? # => nil (since we've not set any hours yet!)

# We want to be open 9am til 6pm on a Monday
InBusiness.hours.monday = "09:00".."18:00"
InBusiness.open? # Returns true if it's Monday between 9am and 6pm, false otherwise
InBusiness.open? DateTime.parse('10am Monday') # => true
InBusiness.closed? DateTime.parse('9pm Monday') # => true

# In our imaginary land, 8th July 2013 is a Monday but a public holiday, so let's add it...
InBusiness.holidays << Date.parse('8th July 2013')
InBusiness.hours.monday # => "09:00".."18:00"
InBusiness.open? DateTime.parse("8th July 2013 12:00") # => false
InBusiness.is_holiday? DateTime.parse("8th July 2013 12:00") # => true
```

## Installation

Add this line to your application's Gemfile:

`gem 'in_business'`

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install in_business`

### Using with Rails

Make sure that the gem is in your Gemfile and that you've `bundle install` -ed,
then create an initializer, for example `config/initializers/in_business.rb`.

In there, you'll want to set your daily hours and any holidays:

```ruby
InBusiness.hours = {
  monday: "09:00".."18:00",
  tuesday: "10:00".."19:00",
  # ...
  saturday: "09:00".."12:00"
}

InBusiness.holidays << Date.parse("25th December 2013")
```

### Using with the [holidays](https://github.com/alexdunae/holidays) gem

Just do something like this, perhaps in your Rails initializer:

```ruby
Holidays.between(Date.civil(2013, 1, 1), 2.years.from_now, :gb).
  map{|holiday| InBusiness.holidays << holiday[:date]}
```

This little technique is inspired by [business_time]([business_time](https://github.com/bokmann/business_time))'s readme!

## Running specs

```
$ bundle
$ rspec spec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
