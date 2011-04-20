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
	NSArray *wordsByFrequency;
	NSDecimalNumber *wordsCount;
	
	id target;
	SEL action;
	
    IBOutlet NSButton *portraitButton;
}

@property (readwrite, assign) id target;
@property (readwrite) SEL action;
@property (readonly) NSDictionary *wordContexts;
@property (readonly) NSArray *wordsByFrequency;
@property (readonly) NSString *name;
@property (readwrite, copy) NSImage *portrait;
@property (readonly) NSDecimalNumber *wordsCount;

- (void)loadSpeeches:(NSArray *)speechPaths;
- (void)loadName:(NSString *)newName;

- (IBAction)relay:(id)sender;

- (NSPoint)viewCenter;

- (NSDecimalNumber *)computedSimilarityTo:(President *)otherPresident;

@end
