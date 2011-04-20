//
//  President.h
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface President : NSViewController {
@private
	NSString *name;
	NSImage *portrait;
	NSArray *speeches;
	
	NSDictionary *wordContexts;
	
    IBOutlet NSButton *portraitButton;
}

@property (readonly, copy) NSDictionary *wordContexts;
@property (readonly, copy) NSString *name;
@property (readwrite, copy) NSImage *portrait;

- (void)loadSpeeches:(NSArray *)speechPaths;
- (void)loadName:(NSString *)newName;

- (NSPoint)viewCenter;

- (NSDecimalNumber *)computedSimilarityTo:(President *)otherPresident;

- (void)setTarget:(id)target;
- (void)setAction:(SEL)action;

@end
