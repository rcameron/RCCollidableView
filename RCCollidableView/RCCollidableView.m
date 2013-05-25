//
//  RCCollidableView.m
//  RCCollidableView
//
//  Created by Rich Cameron on 5/24/13.
//  Copyright (c) 2013 Rich Cameron. All rights reserved.
//

#import "RCCollidableView.h"

@interface RCCollidableView ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, strong) UIView          *contentView;

@end

@implementation RCCollidableView

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (!self)
    return nil;
  
  [self RCCollidableView_commonInit];
  
  return self;
}

////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  
  if (!self)
    return nil;
  
  [self RCCollidableView_commonInit];
  
  return self;
}

////////////////////////////////////////////////////////
- (void)RCCollidableView_commonInit
{
  // Set up bounce defaults
  _bounceHorizontal = YES;
  _bounceVertical = YES;
  
  // Set up scrollview
  _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  [_scrollView setDelegate:self];
  [_scrollView setBounces:YES];
  [_scrollView setClipsToBounds:NO];
  [self updateBounce];
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Bounce
////////////////////////////////////////////////////////
- (void)updateBounce
{
  [_scrollView setAlwaysBounceHorizontal:_bounceHorizontal];
  [_scrollView setAlwaysBounceVertical:_bounceVertical];
}

////////////////////////////////////////////////////////
- (void)setBounceHorizontal:(BOOL)bounceHorizontal
{
  _bounceHorizontal = bounceHorizontal;
  [self updateBounce];
}

////////////////////////////////////////////////////////
- (void)setBounceVertical:(BOOL)bounceVertical
{
  _bounceVertical = bounceVertical;
  [self updateBounce];
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - View Hierarchy Changes
////////////////////////////////////////////////////////
/*
 ========================
 willMoveToSuperview
 Description: Set up scrollView and contentView to match self
 ========================
 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
  // Clear out scroll view
  for (UIView *aView in _scrollView.subviews)
    [aView removeFromSuperview];
  
  // Configure scrollview
  [_scrollView setFrame:self.frame];
  [_scrollView setContentSize:self.bounds.size];
  
  // Configure content view
  _contentView = [self contentView];
  
  // Add content view to scroll view
  [_scrollView addSubview:_contentView];
}

/*
 ========================
 didMoveToSuperview
 Description: Moves our scrollview to the superview in place of self
 ========================
 */
- (void)didMoveToSuperview
{
  // Add our scrollview in place of self
  [self.superview addSubview:_scrollView];
  
  // Hide self, but don't remove from superview or else it may get released!
  [self setHidden:YES];
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Content View
////////////////////////////////////////////////////////
/*
 ========================
 contentView
 Description: Creates a copy of self that can be placed within a scroll view
 ========================
 */
- (UIView *)contentView
{
  UIView *newView = [[UIView alloc] initWithFrame:self.bounds];
  [newView setBackgroundColor:self.backgroundColor];
  
  for (UIView *aView in self.subviews) {
    [newView addSubview:aView];
  }
  
  return newView;
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - ScrollView Delegate
////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  // NSLog(@"scrolling view: %@", ([self.backgroundColor isEqual:[UIColor blueColor]] ? @"Blue" : @"Green"));
  // Calculate current frame taking into account scroll offset
  CGPoint offset = scrollView.contentOffset;
  CGRect myAdjustedFrame = self.frame;
  CGRect myFrame = self.frame;
  
  myAdjustedFrame.origin.x -= offset.x;
  myAdjustedFrame.origin.y -= offset.y;
  
  //NSLog(@"offset = %@", NSStringFromCGPoint(offset));
  
  // Look for other collider views in the same superview
  for (UIView *aView in [self.superview subviews]) {
    if ([aView isEqual:self])
      continue;
    
    if ([aView isMemberOfClass:[RCCollidableView class]]) {
      RCCollidableView *collideView = (RCCollidableView *)aView;
      CGRect yourFrame = collideView.frame;
      CGRect yourAdjustedFrame = yourFrame;
      yourAdjustedFrame.origin.x -= collideView.scrollView.contentOffset.x;
      yourAdjustedFrame.origin.y -= collideView.scrollView.contentOffset.y;
      
      BOOL intersects = CGRectIntersectsRect(myAdjustedFrame, yourFrame);
      
      if (intersects) {
        CGPoint newOffset = collideView.scrollView.contentOffset;
        
        BOOL canCollideHorizontal = CGRectGetMinX(myFrame) >= CGRectGetMaxX(yourFrame) || CGRectGetMaxX(myFrame) <= CGRectGetMinX(yourFrame);
        BOOL canCollideVertical = CGRectGetMinY(myFrame) >= CGRectGetMaxY(yourFrame) || CGRectGetMaxY(myFrame) <= CGRectGetMinY(yourFrame);
        
        if (canCollideHorizontal) {
          BOOL didCollideHorizontal = CGRectGetMinX(myAdjustedFrame) <= CGRectGetMaxX(yourAdjustedFrame) ||
          CGRectGetMaxX(myAdjustedFrame) >= CGRectGetMinX(yourAdjustedFrame);
          
          if (didCollideHorizontal) {
            
            CGFloat leftDiff = CGRectGetMaxX(yourAdjustedFrame) - CGRectGetMinX(myAdjustedFrame);
            CGFloat rightDiff = CGRectGetMaxX(myAdjustedFrame) - CGRectGetMinX(yourAdjustedFrame);
            
            NSLog(@"horizontal: %f | %f", leftDiff, rightDiff);
            
            if (leftDiff > 0 && leftDiff < myFrame.size.width)
              newOffset.x += leftDiff;
            else if (rightDiff > 0 && rightDiff < myFrame.size.width)
              newOffset.x -= rightDiff;
          }
        }
        
        if (canCollideVertical) {
          BOOL didCollideVertical = CGRectGetMinY(myAdjustedFrame) < CGRectGetMaxY(yourAdjustedFrame) ||
          CGRectGetMaxY(myAdjustedFrame) > CGRectGetMinY(yourAdjustedFrame);
          
          if (didCollideVertical) {
            
            CGFloat topDiff = CGRectGetMaxY(yourAdjustedFrame) - CGRectGetMinY(myAdjustedFrame);
            CGFloat bottomDiff = CGRectGetMaxY(myAdjustedFrame) - CGRectGetMinY(yourAdjustedFrame);
            
            if (topDiff > 0 && topDiff < myFrame.size.height)
              newOffset.y += topDiff;
            else if (bottomDiff > 0 && bottomDiff < myFrame.size.height)
              newOffset.y -= bottomDiff;
          }
        }
        
        [collideView.scrollView setContentOffset:newOffset];
      }
    }
  }
}

////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  for (UIView *aView in [self.superview subviews]) {
    if ([aView isEqual:self])
      continue;
    
    if ([aView isMemberOfClass:[RCCollidableView class]]) {
      RCCollidableView *collideView = (RCCollidableView *)aView;
      [collideView.scrollView setContentOffset:CGPointZero];
    }
  }
}

@end
