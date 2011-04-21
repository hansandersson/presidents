//
//  SharedView.m
//  E Pluribus Unum
//
//  Created by Hans Andersson on 11/04/21.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "SharedView.h"


@implementation SharedView

- (void)mouseMoved:(NSEvent *)theEvent
{
	for (NSView *subview in [[self subviews] reverseObjectEnumerator])
	{
		NSRect subviewFrameConverted = [[[self window] contentView] convertRect:[subview frame] fromView:self];
		CGRect subviewFrameConvertedCGRect = CGRectMake(subviewFrameConverted.origin.x, subviewFrameConverted.origin.y, subviewFrameConverted.size.width, subviewFrameConverted.size.height);
		CGPoint eventLocationCGPoint = CGPointMake([theEvent locationInWindow].x, [theEvent locationInWindow].y);
		if (CGRectContainsPoint(subviewFrameConvertedCGRect, eventLocationCGPoint))
		{
			[[self window] makeFirstResponder:subview];
			return;
		}
	}
}

@end
