Template.projectChecklistsTables.helpers
  checklists: -> Checklists.find {_id: {$in: this.checklists}}
  criteria: -> Criteria.find {checklistId: this._id}, {sort: position: 1}

Template.projectSourcesTable.helpers
  sources: -> Sources.find {projectId: this._id}, {sort: {position: 1}}
  has_sources: -> Sources.find({projectId: this._id}).count() > 0

Template.projectFindingsTable.helpers
  findings: -> Findings.find {projectId: this._id}, {sort: {position: 1}}
  has_findings: -> Findings.find({projectId: this._id}).count() > 0
  findingSources: -> Sources.find {_id: {$in: this.sources}}
  findingCriteria: -> Criteria.find {_id: {$in: this.criteria}}
  has_checklists: -> this.checklists and this.checklists.length > 0
  project_has_checklists: ->
    checklists = Template.parentData().checklists
    checklists and checklists.length > 0

Template.projectRisksTable.helpers
  risks: -> Risks.find {projectId: this._id}, {sort: {position: 1}}
  has_risks: -> Risks.find({projectId: this._id}).count() > 0
  riskFindings: -> Findings.find {_id: {$in: this.findings}}

Template.projectMeasuresTable.helpers
  measures: -> Measures.find {projectId: this._id}, {sort: {position: 1}}
  has_measures: -> Measures.find({projectId: this._id}).count() > 0
  measureRisks: -> Risks.find {_id: {$in: this.risks}}
