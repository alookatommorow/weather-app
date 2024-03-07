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

  const onSuccess = (response) => {
    setIsLoading(false);
    setWeather(response);
  }

  useEffect(() => {
    const fetchWeather = async () => {
      setIsLoading(true);

      const response = await request(
        `/api/weather/forecast?query=${query}&zip_code=${zipCode}`,
        {
          onError: () => setError('Something went wrong'),
          onSuccess,
        },
      );

      return response;
    }

    if (query.length > 0) {
      fetchWeather();
    }
  }, [query]);

  const queryFromPlace = (place) => {
    const lat = place.geometry?.location?.lat();
    const lng = place.geometry?.location?.lng();

    if (lat && lng) return `${lat},${lng}`;
  }

  const zipCodeFromPlace = (place) => {
    const detail = place.address_components?.find(addressComponent =>
      addressComponent.types.includes(POSTAL_CODE)
    )
    return detail?.long_name;
  }

  const handleSelect = (place) => {
    const query = queryFromPlace(place);
    if (!query) {
      return setError('Please select a valid address');
    }

    const zipCode = zipCodeFromPlace(place);

    setError('');
    setQuery(query);
    setZipCode(zipCode);
  }

  return (
    <>
      <h1>Get your weather</h1>
      <Autocomplete
        apiKey={process.env.REACT_APP_GOOGLE_KEY}
        onPlaceSelected={handleSelect}
        placeholder="Enter an address"
        className={`google-input${showError ? ' error' : '' }`}
        options={{ types: ['address'] }}
      />
      {showError && <p className="error">{error}</p>}
      {isLoading && <p>Loading...</p>}
      {weather && (
        <Results
          current={weather.current}
          forecast={weather.forecast.forecastday}
        />
      )}
    </>
  );
};
