# README

# Weather Time

Get the weather anywhere in the world! Use the input to select an address to view the current weather and 3-day forecast. Results for are cached by zip code (not all all addressed will have an associated zip code) for 30 minutes. A cache hit is indicated by a green checkmark in the UI.

Built with:

- [Ruby on Rails](https://rubyonrails.org/)
- [React](https://react.dev/) via [Shakapacker](https://github.com/shakacode/shakapacker)

Pulls data from:

- [Free Weather API](https://www.weatherapi.com/docs/)
- [Google Places Autocomplete](https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete) via [react-google-autocomplete](https://github.com/ErrorPro/react-google-autocomplete)

## Prerequisites

- Ruby 3.2.2
- Node.js 14+
- Yarn
- Free Weather API Key (see instructions [here](https://www.weatherapi.com/docs/#intro-getting-started))
- Google API key (see instruction [here](https://developers.google.com/maps/documentation/javascript/get-api-key))

## Setup

Install Ruby dependencies
`bundle install`

Install JS dependencies
`yarn install`

Create .env file
`cp .env/sample .env`

Run Rails server
`bundle exec rails s`

Run tests
`bundle exec rspec`

## Notes

To toggle chaching in development run `rails dev:cache`
