//
//  EPluribusUnumAppDelegate.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/17.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PresidentialSpeechStatisticsProtocol.h"

@class CorpusView;
@class ChartView;

@interface EPluribusUnumAppDelegate : NSObject <NSApplicationDelegate, PresidentialSpeechStatisticsProtocol> {
@private
	NSWindow *window;
	
	NSDictionary *partyColors;
	NSDictionary *presidentParties;
	NSDictionary *wordContexts;
	NSArray *wordsByFrequency;
	NSDecimalNumber *wordsCount;
	
	IBOutlet NSWindow *progressWindow;
	IBOutlet NSProgressIndicator *loadingProgressIndicator;
	
	IBOutlet CorpusView *corpusView;
	IBOutlet ChartView *chartView;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSDictionary *partyColors;
@property (readonly) NSDictionary *presidentParties;

@property (readonly) NSDictionary *wordContexts;
@property (readonly) NSArray *wordsByFrequency;
@property (readonly) NSDecimalNumber *wordsCount;

@property (readwrite, copy) NSColor *color;

@end
