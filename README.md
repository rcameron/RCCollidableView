# RCCollidableView

![demo](https://github.com/rcameron/RCCollidableView/blob/master/RCCollidableView.gif?raw=true)

An iOS component that simulates collisions with other views.

## Installation

- Drag the `RCCollidableView/RCCollidableView` folder into your project


## Usage

To perform collisions, an RCCollidableView will look for other RCCollidableViews within its superview.

```objective-c
// Add a collidable view
RCCollidableView *_collideView = [[RCCollidableView alloc] initWithFrame:CGRectMake(100.f, 100.f, 180.f, 350.f)];
[_collideView setBounceHorizontal:YES];
[_collideView setBackgroundColor:[UIColor blueColor]];
[self.view addSubview:_collideView];
  
// Add another collidable view
RCCollidableView *_collide2View = [[RCCollidableView alloc] initWithFrame:CGRectMake(350.f, 100.f, 180.f, 350.f)];
[_collide2View setBounceHorizontal:YES];
[_collide2View setBackgroundColor:[UIColor greenColor]];
[self.view addSubview:_collide2View];
```
