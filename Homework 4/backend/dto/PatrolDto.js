class PatrolDto{
    constructor(model, distance){
        this.id = model._id;
        this.lat = model.lat;
        this.lon = model.lon;
        this.confidence = model.confidence;
        this.distance = distance;
    }
}

module.exports = PatrolDto;