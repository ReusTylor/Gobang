//
//  ViewController.h
//  Gobang
//
//  Created by 创新创业中心 on 16/8/17.
//  Copyright © 2016年 UESTCACM QKTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineView.h"
#import "ButtonView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) LineView *lineView;
@property (nonatomic, strong) ButtonView * buttonView;

@end
