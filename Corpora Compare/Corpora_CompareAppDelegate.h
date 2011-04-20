//
//  Corpora_CompareAppDelegate.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/17.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Corpora_CompareAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
	
	NSDictionary *partyColors;
	NSDictionary *presidentParties;
	NSDictionary *wordContexts;
	NSArray *wordsByFrequency;
	NSDecimalNumber *wordsCount;
	
	IBOutlet NSWindow *progressWindow;
	IBOutlet NSProgressIndicator *loadingProgressIndicator;
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSDictionary *partyColors;
@property (readonly) NSDictionary *presidentParties;

@property (readonly) NSDictionary *wordContexts;
@property (readonly) NSArray *wordsByFrequency;
@property (readonly) NSDecimalNumber *wordsCount;

@end
