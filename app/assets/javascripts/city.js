function City(data, localeName) {
    if (!data.geometry) {
        throw new Error("Can't find location");
    }

    this.place_id = data.place_id;
    this.provider = data.scope;
    this.lng = data.geometry.location.lng();
    this.lat = data.geometry.location.lat();
    this.address = data.address_components.reduce(function(result, elem) {
        var addrKeys = {city: "locality", country: "country", district: "administrative_area_level_1"};

        for (var key in addrKeys) {
            if (elem.types.includes(addrKeys[key])) {
                result[key] = elem.long_name;
            }
        }
        return result;
    }, {});

    this.localeFullName = localeName;
}
