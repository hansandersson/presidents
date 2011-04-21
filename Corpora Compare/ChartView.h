//
//  ChartView.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PresidentialSpeechStatisticsProtocol.h"

@interface ChartView : NSView {
@private
    id <PresidentialSpeechStatisticsProtocol> representedObject;
	id <PresidentialSpeechStatisticsProtocol> comparedObject;
	
	IBOutlet NSInteger barsCount;
	IBOutlet NSInteger barsOffset;
	double barSpacing;
}

@property (readwrite, assign) id <PresidentialSpeechStatisticsProtocol> representedObject;
@property (readwrite, assign) id <PresidentialSpeechStatisticsProtocol> comparedObject;
@property (readwrite, assign) double barSpacing;
@property (readwrite, assign) NSInteger barsCount;
@property (readwrite, assign) NSInteger barsOffset;

- (IBAction)update:(id)sender;

- (IBAction)incrementBarsCount:(id)sender;
- (IBAction)decrementBarsCount:(id)sender;
- (IBAction)incrementBarsOffset:(id)sender;
- (IBAction)decrementBarsOffset:(id)sender;

@end
