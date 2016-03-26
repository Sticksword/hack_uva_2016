/**
 * Created by michael on 3/26/16.
 */

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var EventSchema   = new Schema({
  name: String
});

module.exports = mongoose.model('Event', EventSchema);