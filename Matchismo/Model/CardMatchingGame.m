//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;   // of Card
@property (strong, readwrite) NSString *resultString;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self ) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.resultString = @"";
    }
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    BOOL pickedAnotherCard = NO;
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.resultString = @"";
        } else {
            // match against another card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    pickedAnotherCard = YES;
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        NSInteger turnPoints = matchScore * MATCH_BONUS;
                        self.score += turnPoints;
                        self.resultString = [NSString stringWithFormat:@"MATCHED %@ with %@ for %ld points",card.contents,otherCard.contents,turnPoints - COST_TO_CHOOSE];
                        card.matched = YES;
                        otherCard.matched = YES;
                    } else {
                        self.resultString = [NSString stringWithFormat:@"%@ does not match %@  %d point PENALTY",card.contents,otherCard.contents,MISMATCH_PENALTY + COST_TO_CHOOSE];
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= COST_TO_CHOOSE;
            if (!pickedAnotherCard)
                self.resultString = [NSString stringWithFormat:@"You picked %@, -%d point",card.contents,COST_TO_CHOOSE];
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (instancetype)init{
    return nil;
}
@end
