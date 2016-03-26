/**
 * Created by michael on 3/26/16.
 */

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var EventSchema = new Schema({
  name: String,
  description: {type: String, default: "generic event" },
  date: {type: Date, default: Date.now },
  likes: {type: Number, default: 0 }
});

module.exports = mongoose.model('Event', EventSchema);