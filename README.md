# README

# Weather App

Get worlwide weather! Use the input to select an address to view the current weather and 3-day forecast. Results for are cached by zip code (not all all addressed will have an associated zip code) for 30 minutes. A cache hit is indicated by a green checkmark in the UI.

Built with:

- [Ruby on Rails](https://rubyonrails.org/)
- [React](https://react.dev/) via [Shakapacker](https://github.com/shakacode/shakapacker)

Pulls data from:

- [Free Weather API](https://www.weatherapi.com/docs/)
- [Google Places Autocomplete](https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete) via [react-google-autocomplete](https://github.com/ErrorPro/react-google-autocomplete)

## Prerequisites

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) 3.2.2
- [Node.js](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs) 14+
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable)
- Free Weather API Key (see instructions [here](https://www.weatherapi.com/docs/#intro-getting-started))
- Google API key (see instruction [here](https://developers.google.com/maps/documentation/javascript/get-api-key))

## Setup

Install Ruby dependencies
`bundle install`

Install JS dependencies
`yarn install`

Create .env file
`cp .env-example .env`

Copy your Google API key and Free Weather API key into `.env`:

```
WEATHER_KEY=myWeatherKey123
REACT_APP_GOOGLE_KEY=myGoogleKey123
```

## Run

Run Rails server
`bundle exec rails s`

Run shakapacker server
`bin/shakapacker-dev-server`

Visit http://localhost:3000/ in your browser

## Test

Run tests
`bundle exec rspec`

## Notes

Rails caching is turned off my default in development mode. To toggle chaching in development run `rails dev:cache`.
