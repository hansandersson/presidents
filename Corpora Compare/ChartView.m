//
//  ChartView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "ChartView.h"


@implementation ChartView

@synthesize barSpacing;
@synthesize representedObject;
@synthesize comparedObject;

- (IBAction)update:(id)sender
{
	(void)sender;
	[self setNeedsDisplay:YES];
}

- (void)setRepresentedObject:(id<PresidentialSpeechStatisticsProtocol>)newRepresentedObject
{
	representedObject = newRepresentedObject;
	[self setNeedsDisplay:YES];
}

- (void)setComparedObject:(id<PresidentialSpeechStatisticsProtocol>)newComparedObject
{
	comparedObject = newComparedObject;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    (void)dirtyRect;
	
	[super drawRect:dirtyRect];
	
	if (!representedObject) return;
	
	[[representedObject color] setFill];
	
	NSSize segmentSize = NSMakeSize((double)([self bounds].size.width) / [barsCountSlider doubleValue], [self bounds].size.height);
	
	for (NSInteger b = 0; b < [barsCountSlider integerValue]; b++)
	{
		NSString *word = [[representedObject wordsByFrequency] objectAtIndex:b];
		double relativeFrequency = (double)[[[representedObject wordContexts] valueForKey:word] count] / (double)[[[representedObject wordContexts] valueForKey:[[representedObject wordsByFrequency] objectAtIndex:0]] count];
		[[NSBezierPath bezierPathWithRect:NSMakeRect(b * segmentSize.width, 0, segmentSize.width - barSpacing,  relativeFrequency * segmentSize.height)] fill];
		
		if (comparedObject)
		{
			double comparativeFrequency = (double)[[[comparedObject wordContexts] valueForKey:word] count] / (double)[[[comparedObject wordContexts] valueForKey:[[comparedObject wordsByFrequency] objectAtIndex:0]] count];
			
			if (comparativeFrequency < relativeFrequency && [[representedObject color] isEqualTo:[comparedObject color]]) [[NSColor blackColor] setStroke];
			else [[comparedObject color] setStroke];
			
			NSBezierPath *comparisonLine = [[NSBezierPath alloc] init];
			[comparisonLine moveToPoint:NSMakePoint(b * segmentSize.width, comparativeFrequency * segmentSize.height)];
			[comparisonLine lineToPoint:NSMakePoint((b+1) * segmentSize.width - barSpacing, comparativeFrequency * segmentSize.height)];
			[comparisonLine stroke];
		}
	}
}

@end
