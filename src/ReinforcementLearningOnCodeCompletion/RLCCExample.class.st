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

{ #category : #examples }
RLCCExample >> exampleSimple2 [

| classes methods relevantMessages relevantContexts rl |
classes := RSAbstractChartPlot withAllSubclasses.
methods := classes flatCollect: #methods.

relevantMessages := methods collect: #selector.
relevantContexts := methods collect: [ :cm |( cm messages asArray intersection: relevantMessages) ].
relevantContexts := relevantContexts select: [ :ms | ms size >= 3 ].

"This reduce the dataset about 12%"
relevantContexts := relevantContexts asSet.

rl := RLCC new.
rl groundContexts: relevantContexts.
rl run
]
