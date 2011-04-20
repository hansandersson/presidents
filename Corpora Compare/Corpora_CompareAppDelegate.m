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
@synthesize partyColors;
@synthesize presidentParties;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSArray *colors = [NSArray arrayWithObjects:[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:1.0], [NSColor greenColor], [NSColor brownColor], [NSColor yellowColor], [NSColor orangeColor], [NSColor cyanColor], [NSColor redColor], [NSColor blueColor], nil];
	
	[[self window] setAcceptsMouseMovedEvents:YES];
	[progressWindow makeKeyAndOrderFront:[aNotification object]];
	[progressWindow becomeFirstResponder];
	[loadingProgressIndicator setUsesThreadedAnimation:YES];
	[loadingProgressIndicator setCanDrawConcurrently:YES];
	
	NSArray *colorInfos = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"txt"] usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSMutableDictionary *partyColorsWorking = [NSMutableDictionary dictionaryWithCapacity:[colors count]];
	for (NSString *colorInfo in colorInfos)
	{
		NSArray *pieces = [colorInfo componentsSeparatedByString:@"	"];
		[partyColorsWorking setValue:[colors objectAtIndex:[[pieces objectAtIndex:1] integerValue]] forKey:[pieces objectAtIndex:0]];
	}
	partyColors = [NSDictionary dictionaryWithDictionary:partyColorsWorking];
	
	NSArray *partyInfos = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Parties" ofType:@"txt"] usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableDictionary *presidentPartiesWorking = [NSMutableDictionary dictionaryWithCapacity:[partyInfos count]];
	for (NSString *partyInfo in partyInfos)
	{
		NSArray *pieces = [partyInfo componentsSeparatedByString:@"	"];
		[presidentPartiesWorking setValue:[pieces objectAtIndex:1] forKey:[pieces objectAtIndex:0]];
	}
	presidentParties = [NSDictionary dictionaryWithDictionary:presidentPartiesWorking];
	
	NSArray *presidentInfos = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Speeches" ofType:@"txt"] usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	[loadingProgressIndicator setIndeterminate:NO];
	[loadingProgressIndicator setMaxValue:[presidentInfos count]];
	[loadingProgressIndicator setDoubleValue:0.0];
	
	NSMutableArray *presidentSpeechesWorking = [NSMutableArray arrayWithCapacity:[presidentInfos count]];
	for (NSString *presidentInfo in presidentInfos)
	{
		NSArray *pieces = [presidentInfo componentsSeparatedByString:@"	"];
		NSString *presidentName = [pieces objectAtIndex:0];
		NSLog(@"Loading %@...", presidentName);
		President *newPresident = [[President alloc] initWithNibName:@"President" bundle:[NSBundle mainBundle]];
		[newPresident loadName:presidentName];
		[newPresident loadSpeeches:[[pieces objectAtIndex:1] componentsSeparatedByString:@" "]];
		[presidentSpeechesWorking addObject:newPresident];
		[(CorpusView *)[window contentView] addPresident:newPresident];
		[loadingProgressIndicator incrementBy:1.0];
	}
	
	[progressWindow close];
	[window makeKeyAndOrderFront:self];
}

@end
