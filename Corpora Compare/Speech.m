//
//  Speech.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "Speech.h"


@implementation Speech

- (id)init
{
    self = [super init];
    if (self) {
        date = nil;
		wordContexts = nil;
    }
    
    return self;
}


- (id)initWithFileName:(NSString *)fileName
{
	self = [self init];
	if (self)
	{
		NSString *speechContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"] usedEncoding:nil error:nil];
		NSArray *sentences = [speechContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".;:—?!"]];
		NSMutableDictionary *wordContextsWorking = [NSMutableDictionary dictionary];
		for (NSString *sentence in sentences)
		{
			NSArray *words = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			for (NSString *word in words)
			{
				if (![wordContextsWorking valueForKey:word]) [wordContextsWorking setValue:[NSMutableArray array] forKey:word];
				[[wordContextsWorking valueForKey:word] addObject:sentence];
			}
		}
		wordContexts = [NSDictionary dictionaryWithDictionary:wordContextsWorking];
	}
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
