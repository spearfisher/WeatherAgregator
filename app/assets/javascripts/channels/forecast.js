App.forecast = App.cable.subscriptions.create("ForecastChannel", {
  received: function(data) {
      console.log("!!!!! received !!!!!!!");
      console.log(data);

      var input = document.getElementById('searchTextField');
      input.readOnly = false;


      if (data.error) {
          console.error(data.error);
          return
      }

      var wrapper = document.getElementById("forecast-wrapper");
      var template = forecastTemplate(data.data);
      wrapper.insertBefore(template, wrapper.firstElementChild);
  },

  fetchForecast: function(city) {
    return this.perform('fetch_forecast', {city: city});
  }
});

function forecastTemplate(data) {
  var html = `
    <div class='card' data-created='${data.created_at}' id='${data.city.id}'>
      <div class='card-header text-center bg-info text-light'>
        <h6>
          <span>${data.city.localeFullName}</span>
          <span>Just now</span>
        </h6>
      </div>
      <div class='card-body bg-info text-light'>
        <div class='row'>`;

  data.forecasts.forEach((f) => {
    html += `
      <div class='col-sm-6'>
        <p>
          <span class='card-title'>Forecast provider:</span>
          <u class='text-uppercase'>${f.provider}</u>
        </p>
        <p>
          <span>Temperature:</span>
            <i class='fa fa-long-arrow-up text-warning'></i>
            <span>${f.t_max}</span>
            <i class='fa fa-long-arrow-down text-primary'></i>
            <span>${f.t_min}</span>
        </p>
        <p>
          <span>Description:</span>
            ${precipIcon(f.precipType) || ""}
            <span>${precipInfo(f.precipType, f.precipProbability)}</span>
        </p>
      </div>`;
  });

    html += `
        </div>
     </div>`;

    return new DOMParser().parseFromString(html, 'text/html').body.childNodes[0]
}

function precipInfo(type, probability) {
  if (!type) return 'Sunny';

  var out = type[0].toUpperCase() + type.slice(1);

  if (probability) {
    out += ` ${parseInt(probability * 100)}%`;
  }

  return out;
}

function precipIcon(type){
  type = type.toLowerCase();
  var icon_class = 'fa-sun-o';

    if (type.includes('cloud')) {
      icon_class = 'fa-cloud';
    }
    else if (type.includes('rain')) {
      icon_class = 'fa-tint';
    }
    else if (type.includes('snow')) {
      icon_class = 'fa-snowflake-o';
    }

   return `<i class='fa ${icon_class} aria-hidden='true'></i>`
}