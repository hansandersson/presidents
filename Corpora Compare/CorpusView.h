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
}

- (void)addPresident:(President *)president;
- (void)positionPresidents;

@end
