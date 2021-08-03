Class {
	#name : #RLCC,
	#superclass : #Object,
	#instVars : [
		'startState',
		'actionMessages',
		'r',
		'numberOfEpisodes',
		'maxEpisodeSteps',
		'minAlpha',
		'gamma',
		'qTable',
		'rewards',
		'epsilon',
		'groundContexts'
	],
	#category : #ReinforcementLearningOnCodeCompletion
}

{ #category : #'as yet unclassified' }
RLCC >> act: aState action: action [
	| newState isDone reward |
	newState := aState copy.
	newState add: action.
	isDone := false.
	(groundContexts includes: newState messages) ifTrue: [ isDone := true. reward  ].
	newState numberOfMessages >= 5
		ifTrue: [ isDone := true ]
		ifFalse: [ isDone := false ].
	^ { newState . reward . isDone }
]

{ #category : #accessing }
RLCC >> actionMessages: someSelectors [

	actionMessages := someSelectors
]

{ #category : #'as yet unclassified' }
RLCC >> actions [
	"Return the considered actions"
	^ #(1 2 3 4)
]

{ #category : #'as yet unclassified' }
RLCC >> chooseAction: state [
	^ r next < epsilon
		ifTrue: [ self actions atRandom: r ]
		ifFalse: [ 
			"Return the best action"
			(self qState: state) argmax ]
]

{ #category : #'as yet unclassified' }
RLCC >> epsilon: aFloat [
	"Set the probability to explore the world. The argument is between 0.0 and 1.0"
	epsilon := aFloat
]

{ #category : #'as yet unclassified' }
RLCC >> groundContexts: someContexts [
	groundContexts := someContexts
]

{ #category : #'as yet unclassified' }
RLCC >> initialize [
	super initialize.
	r := Random seed: 42.
	numberOfEpisodes := 20.
	maxEpisodeSteps := 100.
	minAlpha := 0.02.
	gamma := 1.0.
	epsilon := 0.2.
	qTable := Dictionary new.
	rewards := OrderedCollection new.
	
	actionMessages := OrderedCollection new
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorQTable [
	<inspectorPresentationOrder: 90 title: 'QTable'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualizeQTable;
		yourself
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorQTableContext: aContext [
	aContext withoutEvaluator
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorReward [
	<inspectorPresentationOrder: 90 title: 'Reward'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualizeReward;
		yourself
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorRewardContext: aContext [
	aContext withoutEvaluator
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorStartState [
	<inspectorPresentationOrder: 90 title: 'Start state'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualize;
		yourself
]

{ #category : #'as yet unclassified' }
RLCC >> inspectorStartStateContext: aContext [
	aContext withoutEvaluator
]

{ #category : #'as yet unclassified' }
RLCC >> maxEpisodeSteps: anInteger [
	maxEpisodeSteps := anInteger 
]

{ #category : #'as yet unclassified' }
RLCC >> moveHero: state action: action [
	"Return the new position of a car, as a point. The action is a number from 1 to 4.
	return a new position"
	| delta |
	delta := { 0@ -1 . 0@1 . -1@0 . 1@0 } at: action ifAbsent: [ self error: 'Unknown action' ].
	^ ((state position + delta) min: state grid extent) max: 1 @ 1
]

{ #category : #'as yet unclassified' }
RLCC >> newCar: state action: action [
	"Return the new position of a car, as a point. The action is a number from 1 to 4.
	**Maybe we should have a RLCar class**
	return a new position"
	| delta |
	delta := { 0@ -1 . 0@1 . -1@0 . 1@0 } at: action ifAbsent: [ self error: 'Unknown action' ].
	^ ((state position + delta) min: state grid extent) max: 1 @ 1
]

{ #category : #'as yet unclassified' }
RLCC >> numberOfEpisodes: aNumber [
	numberOfEpisodes := aNumber
]

{ #category : #'as yet unclassified' }
RLCC >> qState: state [ 
	qTable at: state ifAbsentPut: [ (1 to: self actions size) collect: [ :nU | 0 ] ].
	^ qTable at: state
]

{ #category : #'as yet unclassified' }
RLCC >> qState: state action: action [
	qTable at: state ifAbsentPut: [ (1 to: self actions size) collect: [ :nU | 0 ] ].
	^ (qTable at: state) at: action
]

{ #category : #'as yet unclassified' }
RLCC >> run [

	| alphas currentState totalReward alpha isDone currentAction tupple nextState currentReward |
	alphas := (minAlpha to: 1.0 count: numberOfEpisodes) reversed.
	rewards := OrderedCollection new.
	1 to: numberOfEpisodes do: [ :e |
		currentState := startState.
		totalReward := 0.
		alpha := alphas at: e.
		isDone := false.
		maxEpisodeSteps timesRepeat: [ 
			isDone ifFalse: [ 
				currentAction := self chooseAction: currentState.
				tupple := self act: currentState action: currentAction.
				nextState := tupple first.
				currentReward := tupple second.
				isDone := tupple third.
				totalReward := totalReward + currentReward.
				
				(self qState: currentState) at: currentAction put: (
					(self qState: currentState action: currentAction) + (alpha * (currentReward + (gamma * (self qState: nextState) max) - (self qState: currentState action: currentAction)))).
				currentState := nextState
			]
		].
		rewards add: totalReward.
	].
	rewards := rewards asArray.
	^ rewards







]

{ #category : #'as yet unclassified' }
RLCC >> setInitialGrid: aGrid [
	startState := RLState new grid: aGrid; position: 1 @ 1.
]

{ #category : #'as yet unclassified' }
RLCC >> startState [
	^ startState
]

{ #category : #'as yet unclassified' }
RLCC >> visualizeQTable [
	| c state values allBoxes sortedAssociations |
	c := RSCanvas new.
	
	c add: (RSLabel text: 'State').
	c add: (RSLabel text: '^').
	c add: (RSLabel text: 'V').
	c add: (RSLabel text: '<').
	c add: (RSLabel text: '>').
	
	sortedAssociations := qTable associations reverseSortedAs: [ :assoc | assoc value average ].
	sortedAssociations do: [ :assoc |
		state := RSLabel model: assoc key.
		values := RSBox 
						models: (assoc value collect: [ :v | v round: 2 ]) 
						forEach: [ :s :m | s extent: 40 @ 20 ].
		c add: state.
		c addAll: values.
	].
	RSCellLayout new lineItemsCount: 5; gapSize: 1; on: c shapes.
	allBoxes := c shapes select: [ :s | s class == RSBox ].
	RSNormalizer color
		shapes: allBoxes;
		from: Color red; to: Color green;
		normalize.
	allBoxes @ RSLabeled middle.
	^ c @ RSCanvasController
]

{ #category : #'as yet unclassified' }
RLCC >> visualizeReward [
	| c plot |
	c := RSChart new.
	plot := RSLinePlot new.
	plot y: rewards.
	c addPlot: plot.
	c addDecoration: (RSChartTitleDecoration new title: 'Reward evolution'; fontSize: 20).
	c xlabel: 'Episode' offset: 0 @ 10.
	c ylabel: 'Reward' offset: -20 @ 0.
	c addDecoration: (RSHorizontalTick new).
	c addDecoration: (RSVerticalTick new).
	c build.
	^ c canvas
]
