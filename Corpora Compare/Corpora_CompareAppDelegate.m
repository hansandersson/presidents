//
//  Corpora_CompareAppDelegate.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/17.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "Corpora_CompareAppDelegate.h"
#import "President.h"
#import "CorpusView.h"

@implementation Corpora_CompareAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	(void)aNotification;
	[loadingProgressIndicator setUsesThreadedAnimation:YES];
	[loadingProgressIndicator setCanDrawConcurrently:YES];
	
	NSArray *presidentInfos = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Presidents" ofType:@"txt"] usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableArray *presidentsWorking = [NSMutableArray arrayWithCapacity:[presidentInfos count]];
	
	[loadingProgressIndicator setIndeterminate:NO];
	[loadingProgressIndicator setMaxValue:[presidentInfos count]];
	[loadingProgressIndicator setDoubleValue:0.0];
	
	for (NSString *presidentInfo in presidentInfos)
	{
		NSArray *pieces = [presidentInfo componentsSeparatedByString:@"	"];
		NSString *presidentName = [pieces objectAtIndex:0];
		NSLog(@"Loading %@...", presidentName);
		President *newPresident = [[President alloc] initWithNibName:@"President" bundle:[NSBundle mainBundle]];
		[newPresident loadName:presidentName];
		[newPresident loadSpeeches:[[pieces objectAtIndex:1] componentsSeparatedByString:@" "]];
		[presidentsWorking addObject:newPresident];
		[(CorpusView *)[window contentView] addPresident:newPresident];
		[loadingProgressIndicator incrementBy:1.0];
	}
	
	[progressWindow close];
	[window makeKeyAndOrderFront:self];
}

@end
