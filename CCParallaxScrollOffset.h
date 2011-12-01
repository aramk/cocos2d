//
//  CCParallaxScrollOffset.h v1.0
//
//  Created by Aram Kocharyan on 1/12/11
//  http://ak.net84.net/
//

#import "cocos2d.h"

@interface CCParallaxScrollOffset : NSObject {
	CGPoint scrollOffset, origPosition, relVelocity, ratio;
	CCNode *child;
}
@property (readwrite) CGPoint scrollOffset, position, ratio;
@property (readwrite,assign) CCNode *child;
@property (readwrite,assign) CGPoint origPosition, currPosition, relVelocity;
+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s;
+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v;
-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v;
-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s;
@end
