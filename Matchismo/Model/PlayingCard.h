//
//  PlayingCard.h
//  Matchismo
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
