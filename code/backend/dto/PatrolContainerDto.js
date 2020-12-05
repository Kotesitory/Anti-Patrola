class PatrolContainerDto{
    constructor(items){
        this.info = new Metadata(items.length);
        this.patrols = items;
    }
}

class Metadata{
    constructor(itemCount){
        this.itemCount = itemCount;
        this.sort = 'NEWEST_FIRST';
    }
}

module.exports = PatrolContainerDto;