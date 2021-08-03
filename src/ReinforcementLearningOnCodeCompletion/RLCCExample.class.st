Class {
	#name : #RLCCExample,
	#superclass : #Object,
	#category : #ReinforcementLearningOnCodeCompletion
}

{ #category : #examples }
RLCCExample >> exampleSimple [

| classes methods relevantMessages relevantMethods |
classes := RSAbstractChartPlot withAllSubclasses.
methods := classes flatCollect: #methods.

relevantMessages := methods collect: #selector.

relevantMethods := methods collect: [ :cm |( cm messages asArray intersection: relevantMessages) ].
relevantMethods := relevantMethods select: [ :ms | ms size >= 2 ].
relevantMethods := relevantMethods asSet.
]
