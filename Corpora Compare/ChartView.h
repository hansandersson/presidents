//
//  ChartView.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PresidentialSpeechStatisticsProtocol.h"

@class CorpusView;

@interface ChartView : NSView <NSTableViewDataSource> {
@private
    id <PresidentialSpeechStatisticsProtocol> representedObject;
	id <PresidentialSpeechStatisticsProtocol> comparedObject;
	
	IBOutlet CorpusView *corpusView;
	
	NSUInteger barsCount;
	NSUInteger barsOffset;
	NSString *searchWord;
	double barSpacing;
	
	IBOutlet NSSearchField *searchField;
	
	NSMutableArray *exclusions;
	IBOutlet NSTableView *exclusionsTableView;
	
	NSInteger clickedB;
}

@property (readwrite, assign) id <PresidentialSpeechStatisticsProtocol> representedObject;
@property (readwrite, assign) id <PresidentialSpeechStatisticsProtocol> comparedObject;
@property (readwrite, assign) double barSpacing;
@property (readwrite, assign) NSUInteger barsCount;
@property (readwrite, assign) NSUInteger barsOffset;
@property (readwrite, copy) NSString *searchWord;
@property (readonly) NSArray *filteredWordsByFrequency;
@property (readonly) NSSize segmentSize;

- (IBAction)update:(id)sender;

- (IBAction)incrementBarsCount:(id)sender;
- (IBAction)decrementBarsCount:(id)sender;
- (IBAction)incrementBarsOffset:(id)sender;
- (IBAction)decrementBarsOffset:(id)sender;

- (IBAction)takeStringValueFromSender:(id)sender;

- (IBAction)removeAllExclusions:(id)sender;
- (IBAction)removeSelectedExclusion:(id)sender;

@end
