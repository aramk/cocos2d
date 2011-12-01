//
//  CCParallaxScrollNode.h v1.0
//
//  Created by Aram Kocharyan on 1/12/11
//  http://ak.net84.net/
//

#import "cocos2d.h"
#import "CCParallaxScrollOffset.h"

@interface CCParallaxScrollNode : CCNode {
	ccArray *scrollOffsets;
	CCSpriteBatchNode *batch;
}

@property(nonatomic, readwrite) ccArray *scrollOffsets;
@property(nonatomic, assign) CCSpriteBatchNode *batch;

+(id) makeWithBatchFile:(NSString *)file;
-(void) addChild:(CCSprite *)Node z:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)p ScrollOffset:(CGPoint)scrollOffset;
-(void) addChild:(CCSprite *)node z:(NSInteger)z Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v;
-(void) removeChild:(CCSprite *)node cleanup:(BOOL)cleanup;
-(void) updateWithVelocity:(CGPoint)vel AndDelta:(ccTime)dt;
-(void) updateWithYPosition:(float)y AndDelta:(ccTime)dt;

-(void) addInfiniteScrollWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Dir:(CGPoint)dir Objects:(CCSprite*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
-(void) addInfiniteScrollXWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Objects:(CCSprite*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
-(void) addInfiniteScrollYWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Objects:(CCSprite*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

-(void) addInfiniteScrollWithObjects:(CCArray*)objects Z:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Dir:(CGPoint)dir;

@end
