class PatrolDto{
    constructor(model){
        this.id = model._id;
        this.lat = model.lat;
        this.lon = model.lon;
        this.confidence = model.confidence;
    }
}

module.exports = PatrolDto;