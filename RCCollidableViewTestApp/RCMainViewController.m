//
//  RCMainViewController.m
//  RCCollidableView
//
//  Created by Rich Cameron on 5/24/13.
//  Copyright (c) 2013 Rich Cameron. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCCollidableView.h"

@interface RCMainViewController ()

@end

@implementation RCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (!self)
    return nil;
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.9]];
  
  // Add a collidable view
  RCCollidableView *_collideView = [[RCCollidableView alloc] initWithFrame:CGRectMake(100.f, 100.f, 180.f, 350.f)];
 // [_collideView setBounceVertical:NO];
  [_collideView setBounceHorizontal:YES];
  [_collideView setBackgroundColor:[UIColor blueColor]];
  [self.view addSubview:_collideView];
  
  // Add another collidable view
  RCCollidableView *_collide2View = [[RCCollidableView alloc] initWithFrame:CGRectMake(350.f, 100.f, 180.f, 350.f)];
//////////////////////////////////////////////////////// [_collide2View setBounceVertical:NO];
  [_collide2View setBounceHorizontal:YES];
  [_collide2View setBackgroundColor:[UIColor greenColor]];
  [self.view addSubview:_collide2View];
  
  // Add another collidable view
  RCCollidableView *_collide3View = [[RCCollidableView alloc] initWithFrame:CGRectMake(550.f, 100.f, 150.f, 350.f)];
//  [_collide3View setBounceVertical:NO];
  [_collide3View setBounceHorizontal:YES];
  [_collide3View setBackgroundColor:[UIColor redColor]];
  [self.view addSubview:_collide3View];

  // Add another collidable view
  RCCollidableView *_collide4View = [[RCCollidableView alloc] initWithFrame:CGRectMake(350.f, 500.f, 180.f, 350.f)];
  //////////////////////////////////////////////////////// [_collide2View setBounceVertical:NO];
  [_collide4View setBounceHorizontal:YES];
  [_collide4View setBackgroundColor:[UIColor lightGrayColor]];
  [self.view addSubview:_collide4View];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
