//
//  ViewController.m
//  Gobang
//
//  Created by 创新创业中心 on 16/8/17.
//  Copyright © 2016年 UESTCACM QKTeam. All rights reserved.
//

#import "ViewController.h"
#import "ButtonView.h"
#import "LineView.h"
#import "Header.h"


@interface ViewController ()



@end

@implementation ViewController

- (LineView *)lineView{
    if (_lineView == nil) {
        _lineView = [[LineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 )];
        [self.view addSubview:_lineView];
        NSLog(@"Lineview");
    
    }
    return _lineView;
}

- (ButtonView *)buttonView{
    if (_buttonView == nil) {
        _buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [self.view addSubview:_buttonView];
    }
    return _buttonView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews{
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    imageView.frame=self.view.bounds;
    imageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imageView atIndex:0];
    
    
    self.navigationItem.title=@"五子棋";
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"悔棋" style:UIBarButtonItemStylePlain target:self action:@selector(undo)];
    UIBarButtonItem *rightbtn1=[[UIBarButtonItem alloc]initWithTitle:@"Replay" style:UIBarButtonItemStylePlain target:self action:@selector(replay)];
    
    UIBarButtonItem*rightbtn2=[[UIBarButtonItem alloc]initWithTitle:@"记分板" style:UIBarButtonItemStylePlain target:self action:@selector(grade)];
    rightbtn2.tintColor=[UIColor redColor];
   
    self.navigationItem.rightBarButtonItems=@[rightbtn1,rightbtn2];
    
    self.lineView.backgroundColor=[UIColor clearColor];
    
    self.buttonView. backgroundColor=[UIColor clearColor];}


-(void)undo{
    [self.buttonView undo];

}

-(void)replay{
    [self.buttonView replay];
}
-(void)grade{
    [self presentViewController:[self.buttonView grade] animated:YES completion:nil];
    
}
@end
