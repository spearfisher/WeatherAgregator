App.forecast = App.cable.subscriptions.create("ForecastChannel", {
  received: function(data) {
      console.log("!!!!! received !!!!!!!");
      console.log(data);

      var input = document.getElementById('searchTextField');
      input.readOnly = false;

      //TODO: render new forecast log
  },

  fetchForecast: function(city) {
    return this.perform('fetch_forecast', {city: city});
  }
});
