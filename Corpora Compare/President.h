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
	
	id target;
	SEL action;
	
    IBOutlet NSButton *portraitButton;
}

@property (readwrite, assign) id target;
@property (readwrite) SEL action;
@property (readonly, copy) NSDictionary *wordContexts;
@property (readonly, copy) NSString *name;
@property (readwrite, copy) NSImage *portrait;

- (void)loadSpeeches:(NSArray *)speechPaths;
- (void)loadName:(NSString *)newName;

- (IBAction)relay:(id)sender;

- (NSPoint)viewCenter;

- (NSDecimalNumber *)computedSimilarityTo:(President *)otherPresident;

@end
