Measures = new Mongo.Collection('measures');

Measures.allow({
  update: function(userId, measure) { return ownsProjectItem(userId, measure); },
  remove: function(userId, measure) { return ownsProjectItem(userId, measure); },
});

Meteor.methods({
  measureInsert: function(measureAttributes) {
    check(this.userId, String);
    check(measureAttributes, {
      projectId: String,
      title: String,
      description: String,
      risks: Array
    });
    var user = Meteor.user();
    var project = Projects.findOne(measureAttributes.projectId);
    if (!project)
      throw new Meteor.Error('invalid-measure', 'You must add a measure to a project');
    measure = _.extend(measureAttributes, {
      userId: user._id,
      author: user.username,
      submitted: new Date(),
      kind: 'measure'
    });
    // create the measure, save the id
    measure._id = Measures.insert(measure);
    // now create a notification, informing the project members a measure has been added
    for (i = 0; i < project.members.length; i++)
    {
      createNotification(project.members[i], user._id, measure.projectId,
        user.username + ' added measure ' + measure.title + ' to ' + project.title);
    };
    return measure._id;
  }
});

validateMeasure = function(measure) {
  var errors = {};

  if (!measure.title)
    errors.title = TAPi18n.__("Please provide a title");

  if (!measure.risks)
    errors.risks = TAPi18n.__("Please select one or more risks that the measure addresses");

  return errors;
}