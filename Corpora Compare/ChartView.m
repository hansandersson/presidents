//
//  ChartView.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/20.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "ChartView.h"
#import "CorpusView.h"

@implementation ChartView

@synthesize barSpacing;
@synthesize representedObject;
@synthesize comparedObject;
@synthesize barsCount;
@synthesize barsOffset;
@synthesize searchWord;

- (void)setBarsOffset:(NSUInteger)newBarsOffset
{
	barsOffset = newBarsOffset;
	[self setNeedsDisplay:YES]; 
}

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
	[self setSearchWord:nil];
	(void)sender;
	barsOffset += 1;
	[self setNeedsDisplay:YES];
}

- (IBAction)decrementBarsOffset:(id)sender
{
	[self setSearchWord:nil];
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

- (IBAction)takeStringValueFromSender:(id)sender
{
	[self setSearchWord:[sender stringValue]];
}

- (void)setSearchWord:(NSString *)newSearchWord
{
	NSInteger searchWordIndex = NSNotFound;
	if (newSearchWord)
	{
		for (NSString *word in [[self representedObject] wordsByFrequency])
		{
			if ([word isEqualToString:newSearchWord])
			{
				searchWordIndex = [[[self representedObject] wordsByFrequency] indexOfObject:word];
				break;
			}
		}
	}
	searchWord = newSearchWord;
	if (searchWordIndex != NSNotFound) [self setBarsOffset:searchWordIndex];
	else
	{
		searchWord = nil;
		[searchField setStringValue:@""];
		[self setBarsOffset:0];
	}
}

- (void)setRepresentedObject:(id<PresidentialSpeechStatisticsProtocol>)newRepresentedObject
{
	representedObject = newRepresentedObject;
	[self setSearchWord:searchWord];
	[self setNeedsDisplay:YES];
}

- (void)setComparedObject:(id<PresidentialSpeechStatisticsProtocol>)newComparedObject
{
	comparedObject = newComparedObject;
	[self setNeedsDisplay:YES];
}

- (NSSize)segmentSize
{
	return NSMakeSize((double)([self bounds].size.width) / (double)barsCount, [self bounds].size.height);
}

- (void)drawRect:(NSRect)dirtyRect
{
    (void)dirtyRect;
	
	[super drawRect:dirtyRect];
	
	if (!representedObject) return;
	
	NSSize segmentSize = [self segmentSize];
	
	[[representedObject color] setFill];
	
	NSMutableDictionary *stringDrawAttributes = [[NSMutableDictionary alloc] init];
	[stringDrawAttributes setValue:[representedObject color] forKey:NSForegroundColorAttributeName];
	NSShadow *stringShadow = [[NSShadow alloc] init];
	[stringShadow setShadowColor:[NSColor blackColor]];
	[stringShadow setShadowOffset:NSMakeSize(0, 0)];
	[stringShadow setShadowBlurRadius:4];
	[stringDrawAttributes setValue:stringShadow forKey:NSShadowAttributeName];
	
	[stringDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:48.0] forKey:NSFontAttributeName];
	for (double size_2 = 96.0; [[NSString stringWithString:@" "] sizeWithAttributes:stringDrawAttributes].height > segmentSize.width - barSpacing; [stringDrawAttributes setValue:[NSFont fontWithName:@"Goudy Old Style" size:(--size_2)/2.0] forKey:NSFontAttributeName]);
	
	NSArray *filteredWordsByFrequency = [self filteredWordsByFrequency];
	
	NSMutableArray *comparisonWordsFilteredByFrequency;
	if (comparedObject)
	{
		comparisonWordsFilteredByFrequency = [NSMutableArray arrayWithArray:[comparedObject wordsByFrequency]];
		[comparisonWordsFilteredByFrequency removeObjectsInArray:exclusions];
	}
	
	for (NSUInteger b = 0; b < barsCount && b < [filteredWordsByFrequency count]; b++)
	{
		NSString *word = [filteredWordsByFrequency objectAtIndex:(b + barsOffset)];
		double relativeFrequency = (double)[[[representedObject wordContexts] valueForKey:word] count] / (double)[[[representedObject wordContexts] valueForKey:[filteredWordsByFrequency objectAtIndex:0]] count];
		[[NSBezierPath bezierPathWithRect:NSMakeRect(b * segmentSize.width, 0, segmentSize.width - barSpacing,  relativeFrequency * segmentSize.height)] fill];
		
		if (comparedObject && [[comparedObject wordContexts] valueForKey:word])
		{
			double comparativeFrequency = (double)[[[comparedObject wordContexts] valueForKey:word] count] / (double)[[[comparedObject wordContexts] valueForKey:[comparisonWordsFilteredByFrequency objectAtIndex:0]] count];
			
			if (comparativeFrequency < relativeFrequency && [[representedObject color] isEqualTo:[comparedObject color]]) [[NSColor blackColor] setStroke];
			else [[comparedObject color] setStroke];
			
			NSBezierPath *comparisonLine = [[NSBezierPath alloc] init];
			[comparisonLine moveToPoint:NSMakePoint(b * segmentSize.width, comparativeFrequency * segmentSize.height)];
			[comparisonLine lineToPoint:NSMakePoint((b+1) * segmentSize.width - barSpacing, comparativeFrequency * segmentSize.height)];
			[comparisonLine stroke];
		}
		NSAffineTransform *transform = [NSAffineTransform transform];
		[transform translateXBy:((b + 1) * segmentSize.width) - barSpacing yBy:segmentSize.height - [word sizeWithAttributes:stringDrawAttributes].width];
		[transform rotateByDegrees:90];
		[transform concat];
		[word drawAtPoint:NSMakePoint(0, 0) withAttributes:stringDrawAttributes];
		[transform invert];
		[transform concat];
	}
}

- (NSArray *)filteredWordsByFrequency
{
	NSMutableArray *filteredWordsByFrequency = [NSMutableArray arrayWithArray:[representedObject wordsByFrequency]];
	[filteredWordsByFrequency removeObjectsInArray:exclusions];
	return filteredWordsByFrequency;
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	[super mouseMoved:theEvent];
	[corpusView setFocusWord:[[self filteredWordsByFrequency] objectAtIndex:(NSInteger) ([self convertPointFromBase:[theEvent locationInWindow]].x / [self segmentSize].width)]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];
	clickedB = (NSInteger) ([self convertPointFromBase:[theEvent locationInWindow]].x / [self segmentSize].width);
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[super mouseUp:theEvent];
	NSInteger unclickedB = (NSInteger) ([self convertPointFromBase:[theEvent locationInWindow]].x / [self segmentSize].width);
	if (clickedB == unclickedB)
	{
		if (!exclusions) exclusions = [NSMutableArray array];
		[exclusions addObject:[[self filteredWordsByFrequency] objectAtIndex:clickedB]];
		[exclusionsTableView reloadData];
		[self setNeedsDisplay:YES];
	}
	clickedB = -1;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)tableView;
	return [exclusions count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)tableView;
	(void)tableColumn;
	return [exclusions objectAtIndex:row];
}

- (IBAction)removeAllExclusions:(id)sender
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)sender;
	[exclusions removeAllObjects];
	[exclusionsTableView reloadData];
	[self setNeedsDisplay:YES];
}

- (IBAction)removeSelectedExclusion:(id)sender
{
	if (!exclusions) exclusions = [NSMutableArray array];
	(void)sender;
	[exclusions removeObjectAtIndex:[exclusionsTableView selectedRow]];
	[exclusionsTableView reloadData];
	[self setNeedsDisplay:YES];
}

@end
