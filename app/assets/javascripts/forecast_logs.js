document.addEventListener("DOMContentLoaded", function(event) {
    var input = document.getElementById('searchTextField');

    var options = {
        types: ['(cities)']
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
        var city = new City(autocomplete.getPlace(), input.value);

        console.log(city);
        var existed_log = document.getElementById(city.id)

        if (existed_log == null
            || parseInt((new Date - new Date(existed_log.dataset.created)) / (1000 * 3600)) > 4) {

            input.readOnly = true;
            App.forecast.fetchForecast(city);
        } else {
            existed_log.scrollIntoView();
        }
    });
});
