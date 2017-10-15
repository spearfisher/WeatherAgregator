function City(data, localeName) {
    if (!data.geometry) {
        throw new Error("Can't find location");
    }
    this.id = data.id;
    this.lng = data.geometry.location.lng();
    this.lat = data.geometry.location.lat();
    this.localeFullName = localeName;
}
