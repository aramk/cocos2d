//
//  CCParallaxScrollNode.m v1.0
//
//  Created by Aram Kocharyan on 1/12/11
//  http://ak.net84.net/
//

#import "CCParallaxScrollNode.h"

#ifndef PTM_RATIO
	#define PTM_RATIO 32
#endif

#ifndef SIGN
	#define SIGN(x) ((x < 0) ? -1 : (x > 0))
#endif

@interface CCParallaxScrollNode (hidden)
-(void) update:(ccTime)dt;
@end

@implementation CCParallaxScrollNode

@synthesize scrollOffsets, batch;

-(id) init {
	if ( (self=[super init]) ) {
		scrollOffsets = ccArrayNew(5);
	}
	return self;
}

// Uses a CCSpriteBatchNode for your parallax sprites
+(id) makeWithBatchFile:(NSString *)file {
	CCParallaxScrollNode *parallax = [self node];
	parallax.batch = [CCSpriteBatchNode batchNodeWithFile: [NSString stringWithFormat:@"%@.png", file]];
	[parallax addChild:parallax.batch];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat:@"%@.plist", file]];
	return parallax;
}

// Used with box2d style velocity (m/s where m = 32 pixels), but box2d is not required
-(void) updateWithVelocity:(CGPoint)vel AndDelta:(ccTime)dt {
	CGSize screen = [CCDirector sharedDirector].winSize;
	
	vel = ccpMult(vel, PTM_RATIO);
	
	for (int i=scrollOffsets->num - 1; i >= 0; i--) {
		CCParallaxScrollOffset *scrollOffset = scrollOffsets->arr[i];
		CCNode *child = scrollOffset.child;
		
		CGPoint relVel = ccpMult(scrollOffset.relVelocity, PTM_RATIO);
		CGPoint totalVel = ccpAdd(vel, relVel);
		
		CGPoint offset = ccpCompMult(ccpMult(totalVel, dt), scrollOffset.ratio);
		child.position = ccpAdd(child.position, offset);
		
		if ( (vel.x < 0 && child.position.x + child.contentSize.width < 0) ||
			 (vel.x > 0 && child.position.x > screen.width) ) {
			child.position = ccpAdd(child.position, ccp(-SIGN(vel.x) * fabs(scrollOffset.scrollOffset.x), 0));
		}
		
		// Positive y indicates upward movement in cocos2d
		if ( (vel.y < 0 && child.position.y + child.contentSize.height < 0) ||
			(vel.y > 0 && child.position.y > screen.height) ) {
			child.position = ccpAdd(child.position, ccp(0, -SIGN(vel.y) * fabs(scrollOffset.scrollOffset.y)));
		}
	}
}

/* Independent function to move parallax sprites up and down without the use of Y velocity, which could
lead to divergence from an initial Y position for the parallax (eg. ground) if the object starts in free fall etc. */
-(void) updateWithYPosition:(float)y AndDelta:(ccTime)dt {	
	for (int i=scrollOffsets->num - 1; i >= 0; i--) {
		CCParallaxScrollOffset *scrollOffset = scrollOffsets->arr[i];
		CCNode *child = scrollOffset.child;
		float offset = y * scrollOffset.ratio.y;//ccpCompMult(pos, scrollOffset.ratio);
		child.position = ccp(child.position.x, scrollOffset.origPosition.y + offset);
	}
}

-(void) addChild:(CCSprite *)node z:(NSInteger)z Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s RelVelocity:(CGPoint)v {
	node.anchorPoint = ccp(0,0);
	CCParallaxScrollOffset *obj = [CCParallaxScrollOffset scrollWithNode:node Ratio:r Pos:p ScrollOffset:s RelVelocity:v];
	ccArrayAppendObjectWithResize(scrollOffsets, obj);
	if (batch) {
		[batch addChild:node z:z];
	} else {
		[self addChild:node z:z];
	}
}

-(void) addChild:(CCSprite *)node z:(NSInteger)z Ratio:(CGPoint)r Pos:(CGPoint)p ScrollOffset:(CGPoint)s {
	[self addChild:node z:z Ratio:r Pos:p ScrollOffset:s RelVelocity:ccp(0,0)];
}

-(void) removeChild:(CCSprite*)node cleanup:(BOOL)cleanup {
	for (int i=0; i < scrollOffsets->num; i++) {
		CCParallaxScrollOffset *scrollOffset = scrollOffsets->arr[i];
		if( [scrollOffset.child isEqual:node] ) {
			ccArrayRemoveObjectAtIndex(scrollOffsets, i);
			break;
		}
	}
	if (batch) {
		[batch removeChild:node cleanup:cleanup];
	}
}

-(void) removeAllChildrenWithCleanup:(BOOL)cleanup {
	ccArrayRemoveAllObjects(scrollOffsets);
	if (batch) {
		[batch removeAllChildrenWithCleanup:cleanup];
	}
}

// This is the base helper method which prepares your sprites for infinite parallax (hence, infinite fun).
-(void) addInfiniteScrollWithObjects:(CCArray*)objects Z:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Dir:(CGPoint)dir {
	// NOTE: corrects for 1 pixel at end of each sprite to avoid thin lines appearing
	
	// Calculate total width and height
	float totalWidth = 0;
	float totalHeight = 0;
	for (int i = 0; i < objects.count; i++) {
		CCSprite *object = (CCSprite *)[objects objectAtIndex:i];
		totalWidth += object.contentSize.width - 1;
		totalHeight += object.contentSize.height - 1;
	}

	// Position objects, add to parallax
	CGPoint currPos = pos;
	for (int i = 0; i < objects.count; i++) {
		CCSprite *object = (CCSprite *)[objects objectAtIndex:i];
		[self addChild:object z:z Ratio:ratio Pos:currPos ScrollOffset:ccp(totalWidth, totalHeight)];
		CGPoint nextPosOffset = ccp(dir.x * (object.contentSize.width - 1), dir.y * (object.contentSize.height - 1));
		currPos = ccpAdd(currPos, nextPosOffset);
	}
}

-(void) addInfiniteScrollWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Dir:(CGPoint)dir Objects:(CCSprite*)firstObject, ... {
	va_list args;
    va_start(args, firstObject);
	
	CCArray* argArray = [CCArray arrayWithCapacity:2];
	for (CCSprite *arg = firstObject; arg != nil; arg = va_arg(args, CCSprite*)) {
		[argArray addObject:arg];
	}
	va_end(args);
	
	[self addInfiniteScrollWithObjects:argArray Z:z Ratio:ratio Pos:pos Dir:dir];
}

-(void) addInfiniteScrollXWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Objects:(CCSprite*)firstObject, ... {
	va_list args;
    va_start(args, firstObject);
	
	CCArray* argArray = [CCArray arrayWithCapacity:2];
	for (CCSprite *arg = firstObject; arg != nil; arg = va_arg(args, CCSprite*)) {
		[argArray addObject:arg];
	}
	va_end(args);
	
	[self addInfiniteScrollWithObjects:argArray Z:z Ratio:ratio Pos:pos Dir:ccp(1,0)];
}

-(void) addInfiniteScrollYWithZ:(NSInteger)z Ratio:(CGPoint)ratio Pos:(CGPoint)pos Objects:(CCSprite*)firstObject, ... {
	va_list args;
    va_start(args, firstObject);
	
	CCArray* argArray = [CCArray arrayWithCapacity:2];
	for (CCSprite *arg = firstObject; arg != nil; arg = va_arg(args, CCSprite*)) {
		[argArray addObject:arg];
	}
	va_end(args);
	
	[self addInfiniteScrollWithObjects:argArray Z:z Ratio:ratio Pos:pos Dir:ccp(0,1)];
}

- (void) dealloc {
	if (scrollOffsets) {
		ccArrayFree(scrollOffsets);
		scrollOffsets = nil;
	}
	[super dealloc];
}

@end







