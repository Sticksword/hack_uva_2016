/**
 * Created by michael on 3/26/16.
 */

var express = require('express');
var router = express.Router();

var mongoose   = require('mongoose');
var url = 'mongodb://localhost:27017/hack_uva';
mongoose.connect(url);

var Event = require('../models/event');

// middleware to use for all requests
router.use(function(req, res, next) {
  // do logging
  console.log('Something is happening.');
  next(); // make sure we go to the next routes and don't stop here
});

router.get('/', function(req, res) {
  res.json({ message: 'hooray! welcome to our api!' });
});

// on routes that end in /events
// ----------------------------------------------------
router.route('/events')

  // create an event (accessed at POST http://localhost:3000/api/events)
  .post(function(req, res) {

    var event = new Event();      // create a new instance of the Event model
    event.name = req.body.name;  // set the event's name (comes from the request)

    // save the event and check for errors
    event.save(function(err) {
      if (err)
        res.send(err);

      res.json({ message: 'Event created!' });
    });

  })

  // get all the events (accessed at GET http://localhost:3000/api/events)
  .get(function(req, res) {
    Event.find(function(err, events) {
      if (err)
        res.send(err);

      res.json(events);
    });
  });

// on routes that end in /events/:event_id
// ----------------------------------------------------
router.route('/events/:event_id')

  // get the bear with that id (accessed at GET http://localhost:3000/api/events/:event_id)
  .get(function(req, res) {
    Event.findById(req.params.event_id, function(err, event) {
      if (err)
        res.send(err);
      res.json(event);
    });
  })

  // update the event with this id (accessed at PUT http://localhost:3000/api/events/:event_id)
  .put(function(req, res) {

    // use our event model to find the event we want
    Event.findById(req.params.event_id, function(err, event) {

      if (err)
        res.send(err);

      // update the event info
      if (req.body.name != null)
        event.name = req.body.name;

      if (req.body.description != null)
        event.description = req.body.description;



      // save the event
      event.save(function(err) {
        if (err)
          res.send(err);

        res.json({ message: 'Event updated!' });
      });

    });
  })

  // delete the event with this id (accessed at DELETE http://localhost:3000/api/events/:event_id)
  .delete(function(req, res) {
    Event.remove({
      _id: req.params.event_id
    }, function(err, event) {
      if (err)
        res.send(err);

      res.json({ message: 'Successfully deleted' });
    });
  });



module.exports = router;
