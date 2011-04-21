//
//  Speech.m
//  Corpora Compare
//
//  Created by Hans Andersson on 11/04/18.
//  Copyright 2011 Ultramentem. All rights reserved.
//

#import "Speech.h"


@implementation Speech

@synthesize wordContexts;

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
				NSString *key = [[word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
				if (![key isEqualToString:@""])
				{
					if (![wordContextsWorking valueForKey:key]) [wordContextsWorking setValue:[NSMutableArray array] forKey:key];
					[[wordContextsWorking valueForKey:key] addObject:sentence];
				}
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
