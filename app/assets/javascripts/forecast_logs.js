document.addEventListener("DOMContentLoaded", function(event) {
    var input = document.getElementById('searchTextField');

    var options = {
        types: ['(cities)']
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
        var place = new City(autocomplete.getPlace(), input.value);
        postForecastLog(place);
    });
});

function postForecastLog(city) {
    var options = {
        method: "post",
        headers: {
            'Content-type': 'application/json',
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        credentials: 'same-origin',
        body: JSON.stringify(city)
    };

    fetch('/forecast_logs', options)
        .then(function(response) {
            console.log(response.json());
        })
        .catch( console.error );
}
