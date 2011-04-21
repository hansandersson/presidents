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
@synthesize barsCount;
@synthesize barsOffset;

- (IBAction)incrementBarsCount:(id)sender
{
	(void)sender;
	barsCount += 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)decrementBarsCount:(id)sender
{
	(void)sender;
	if (barsCount == 1) return;
	barsCount -= 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)incrementBarsOffset:(id)sender
{
	(void)sender;
	barsOffset += 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)decrementBarsOffset:(id)sender
{
	(void)sender;
	if (!barsOffset) return;
	barsOffset -= 1;
	[self setNeedsDisplay:YES];
}

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
	
	NSSize segmentSize = NSMakeSize((double)([self bounds].size.width) / (double)barsCount, [self bounds].size.height);
	
	NSMutableDictionary *stringDrawAttributes = [[NSMutableDictionary alloc] init];
	[stringDrawAttributes setValue:[representedObject color] forKey:NSForegroundColorAttributeName];
	NSShadow *stringShadow = [[NSShadow alloc] init];
	[stringShadow setShadowColor:[NSColor blackColor]];
	[stringShadow setShadowOffset:NSMakeSize(0, 0)];
	[stringShadow setShadowBlurRadius:4];
	[stringDrawAttributes setValue:stringShadow forKey:NSShadowAttributeName];
	
	[stringDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:48.0] forKey:NSFontAttributeName];
	for (double size_2 = 96.0; [[NSString stringWithString:@" "] sizeWithAttributes:stringDrawAttributes].height > segmentSize.width - barSpacing; [stringDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:(--size_2)/2.0] forKey:NSFontAttributeName]);
	
	for (NSInteger b = 0; b < barsCount; b++)
	{
		NSString *word = [[representedObject wordsByFrequency] objectAtIndex:(b + barsOffset)];
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
		NSAffineTransform *transform = [NSAffineTransform transform];
		[transform translateXBy:((b + 1) * segmentSize.width) - barSpacing yBy:0.0];
		[transform rotateByDegrees:90];
		[transform concat];
		[word drawAtPoint:NSMakePoint(0, 0) withAttributes:stringDrawAttributes];
		[transform invert];
		[transform concat];
	}
}

@end
