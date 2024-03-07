import React, { useState, useEffect } from 'react';
import Autocomplete from 'react-google-autocomplete';
import { request } from '../../utils/request'

export const Results = ({current, forecast}) => {

// maxtemp_f
// condition.text
// condition.icon
  return (
    <>
      <h4>Current Weather</h4>
      <p>{current.condition.text}</p>
      <img src={current.condition.icon} />
      <p>{current.temp_f}°</p>
      <h4>Forecast</h4>
      <div className="forecast-container">
        {forecast?.map(day => (
          <div key={day.date}>
            <h5>{day.date}</h5>
            <p>{day.day.condition.text}</p>
            <img src={day.day.condition.icon} />
            <p>High: {day.day.maxtemp_f}°</p>
            <p>Low: {day.day.mintemp_f}°</p>
          </div>
        ))}
      </div>
    </>
  );
};
