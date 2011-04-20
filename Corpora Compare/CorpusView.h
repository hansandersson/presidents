//
//  CorpusView.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class President;

@interface CorpusView : NSView {
@private
    NSMutableArray *presidents;
	NSDecimalNumber *maximumSimilarity;
	NSDecimalNumber *minimumSimilarity;
	NSMutableDictionary *similarities;
	President *highlight;
	President *selection;
}

- (IBAction)select:(id)sender;

- (void)addPresident:(President *)president;
- (void)positionPresidents;

- (void)subviewFrameDidChange;

@end
