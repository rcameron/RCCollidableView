//
//  RCCollidableView.h
//  RCCollidableView
//
//  Created by Rich Cameron on 5/24/13.
//  Copyright (c) 2013 Rich Cameron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCollidableView : UIView

/** 
 ** Currently, only one bounce direction is allowed at a time.
 ** This limitation will be removed once better 2d collisions are implemented
 */
@property (nonatomic) BOOL    bounceVertical;     // defaults to NO
@property (nonatomic) BOOL    bounceHorizontal;   // defaults to YES

@end
