/**
 * Created by michael on 3/26/16.
 */

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var EventSchema = new Schema({
  name: {type: String, default: "generic event name" },
  description: {type: String, default: "generic event description" },
  date: {type: Date, default: Date.now },
  host: {type: String, default: null },
  interested: {type: Number, default: 0 },
  attending: {type: Number, default: 0 },
  fb_event_id: {type: String, default: null },
  location: {type: String, default: null },
  photo_url: {type: String, default: null }

});

module.exports = mongoose.model('Event', EventSchema);