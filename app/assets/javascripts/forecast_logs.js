document.addEventListener("DOMContentLoaded", function(event) {
    var input = document.getElementById('searchTextField');

    var options = {
        types: ['(cities)']
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
        var city = new City(autocomplete.getPlace(), input.value);
        App.forecast.fetchForecast(city);
    });
});
