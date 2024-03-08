import React, { useState, useEffect } from 'react';
import Autocomplete from 'react-google-autocomplete';
import { Results } from './Results'
import { request } from '../../utils/request'

const POSTAL_CODE = 'postal_code';

export const Weather = () => {
  const [error, setError] = useState('');
  const [query, setQuery] = useState('');
  const [zipCode, setZipCode] = useState('');
  const [weather, setWeather] = useState();
  const [isLoading, setIsLoading] = useState(false);
  const showError = error.length > 0;
  const showWeather = !isLoading && weather !== undefined;

  const onSuccess = (response) => {
    setIsLoading(false);
    setWeather(response);
  }

  const onError = (message) => {
    setIsLoading(false);
    setError(message);
  }

  useEffect(() => {
    const fetchWeather = async () => {
      setIsLoading(true);
      let url = `/api/weather/forecast?query=${query}`;
      if (zipCode) url += `&zip_code=${zipCode}`;

      const response = await request(url, { onError, onSuccess });

      return response;
    }

    if (query.length > 0) {
      fetchWeather();
    }
  }, [query]);

  const placeCoordinates = (place) => {
    const lat = place.geometry?.location?.lat();
    const lng = place.geometry?.location?.lng();

    if (lat && lng) return `${lat},${lng}`;
  }

  const placeZipCode = (place) => {
    const detail = place.address_components?.find(addressComponent =>
      addressComponent.types.includes(POSTAL_CODE)
    )
    return detail?.long_name;
  }

  const handleSelect = (place) => {
    const coordinates = placeCoordinates(place);
    if (!coordinates) {
      return setError('Please select a valid address');
    }

    const zipCode = placeZipCode(place);

    setError('');
    setQuery(coordinates);
    setZipCode(zipCode);
  }

  return (
    <>
      <div className="header">
        <img src="https://cdn.weatherapi.com/weather/64x64/day/176.png" alt="" />
        <h1>Weather Time</h1>
        <img src="https://cdn.weatherapi.com/weather/64x64/day/176.png" alt="" />
      </div>
      <Autocomplete
        apiKey={process.env.REACT_APP_GOOGLE_KEY}
        onPlaceSelected={handleSelect}
        placeholder="Enter an address"
        className={`google-input${showError ? ' error' : '' }`}
        options={{ types: ['address'] }}
      />
      {showError && <p className="error">{error}</p>}
      {isLoading && <p>Loading...</p>}
      {showWeather && weather.cache_hit && (
        <p className="cache">	&#x2705; Cache hit for zip code: {zipCode}</p>
      )}
      {showWeather && (
        <Results
          current={weather.current}
          forecast={weather.forecast.forecastday}
        />
      )}
    </>
  );
};
