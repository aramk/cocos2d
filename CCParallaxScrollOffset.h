//
//  MyClass.h
//  SpaceTest
//
//  Created by Aram Kocharyan on 18/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCParallaxScrollOffset : NSObject {
	CGPoint scrollOffset, origPosition, relVelocity, ratio;
	CCNode *child;
	//CGPoint origPosition, currPosition;
}
@property (readwrite) CGPoint scrollOffset, position, ratio;
@property (readwrite,assign) CCNode *child;
@property (readwrite,assign) CGPoint origPosition, currPosition, relVelocity;
+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s;
+(id) scrollWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v;
-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v;
-(id) initWithNode:(CCNode *)node Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s;
@end
