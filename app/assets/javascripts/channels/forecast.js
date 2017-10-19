App.forecast = App.cable.subscriptions.create("ForecastChannel", {
  received: function(data) {
      console.log("!!!!! received !!!!!!!");
      console.log(data);
  },

  fetchForecast: function(city) {
    return this.perform('fetch_forecast', {city: city});
  }
});
