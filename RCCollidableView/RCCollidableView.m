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
  _bounceVertical = NO;
  
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
  _bounceVertical = bounceHorizontal == YES ? NO : _bounceVertical;
  [self updateBounce];
}

////////////////////////////////////////////////////////
- (void)setBounceVertical:(BOOL)bounceVertical
{
  _bounceVertical = bounceVertical;
  _bounceHorizontal = bounceVertical == YES ? NO : _bounceHorizontal;
  [self updateBounce];
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - View Hierarchy Changes
////////////////////////////////////////////////////////
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

/*
 ========================
 layoutSubviews
 Description: Set up and rebuild scrollView and contentView
 ========================
 */
- (void)layoutSubviews
{
  [super layoutSubviews];
  
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
  if (_bounceHorizontal)
    [self handleHorizontalCollisions];
  else if (_bounceVertical)
    [self handleVerticalCollisions];
}

////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  for (UIView *aView in [self.superview subviews]) {
    if ([aView isEqual:self])
      continue;
    
    if ([aView isMemberOfClass:[RCCollidableView class]]) {
      RCCollidableView *collideView = (RCCollidableView *)aView;
      [collideView.scrollView setContentOffset:CGPointZero animated:YES];
    }
  }
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Collision Handling
////////////////////////////////////////////////////////
- (void)handleHorizontalCollisions
{
  CGRect myAdjustedFrame = self.frame;
  CGPoint myOffset = _scrollView.contentOffset;
  
  myAdjustedFrame.origin.x -= myOffset.x;
  myAdjustedFrame.origin.y -= myOffset.y;
  
  // Loop through all subviews
  for (UIView *aView in [self.superview subviews]) {
    // Skip ourself
    if ([aView isEqual:self])
      continue;
    
    // Make sure we're looking at another collidable view
    if (![aView isKindOfClass:[RCCollidableView class]])
      continue;
    
    // Cast the view to our class
    RCCollidableView *collideView = (RCCollidableView *)aView;
  
    // Check for a collision
    CGRect collideFrame = collideView.frame;
    CGRect intersection = CGRectIntersection(myAdjustedFrame, collideFrame);
    
    if (CGRectIsNull(intersection)) {
      continue;
    }
    
    // Get offset from intersection rect
    CGPoint collideOffset = CGPointZero;
    collideOffset.x = intersection.size.width;
    collideOffset.x *= (myOffset.x < 0) ? -1 : 1; // flip the sign if we're moving to the right
    
    [collideView.scrollView setContentOffset:collideOffset animated:NO];
  }
}

////////////////////////////////////////////////////////
- (void)handleVerticalCollisions
{
  CGRect myAdjustedFrame = self.frame;
  CGPoint myOffset = _scrollView.contentOffset;
  
  myAdjustedFrame.origin.x -= myOffset.x;
  myAdjustedFrame.origin.y -= myOffset.y;
  
  // Loop through all subviews
  for (UIView *aView in [self.superview subviews]) {
    // Skip ourself
    if ([aView isEqual:self])
      continue;
    
    // Make sure we're looking at another collidable view
    if (![aView isKindOfClass:[RCCollidableView class]])
      continue;
    
    // Cast the view to our class
    RCCollidableView *collideView = (RCCollidableView *)aView;
    
    // Check for a collision
    CGRect collideFrame = collideView.frame;
    CGRect intersection = CGRectIntersection(myAdjustedFrame, collideFrame);
    
    if (CGRectIsNull(intersection)) {
      continue;
    }
    
    // Get offset from intersection rect
    CGPoint collideOffset = CGPointZero;
    collideOffset.y = intersection.size.height;
    collideOffset.y *= (myOffset.y < 0) ? -1 : 1; // flip the sign if we're moving to the right
    
    [collideView.scrollView setContentOffset:collideOffset animated:NO];
  }
}

@end
