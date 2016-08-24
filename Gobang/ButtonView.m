//
//  ButtonView.m
//  Gobang
//
//  Created by 创新创业中心 on 16/8/17.
//  Copyright © 2016年 UESTCACM QKTeam. All rights reserved.
//

#import "ButtonView.h"
#import "Header.h"

@interface ButtonView ()<UIAlertViewDelegate>
{
    NSInteger count;
    NSMutableArray *left;
    NSMutableArray *right;
}
@property(nonatomic,strong) NSMutableArray *mArry;
@property(nonatomic,assign) BOOL isSuccess;

@end

@implementation ButtonView
@synthesize mArry=mArry;



-(NSMutableArray*)mArry{
   if (mArry==nil) {
        mArry=[[NSMutableArray alloc]init];
    }
    return mArry;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initLeftRightArr];
    }
    return self;
}


 - (void)initViews{
     NSInteger index= Columnssss*ROW;
     for (NSInteger i=0; i<index; i++) {
         NSInteger row=i/Columnssss;
         NSInteger colum=i%(NSInteger)Columnssss;
         CGFloat X=colum*QPWH-QZWH/2+QPWH;
         CGFloat Y=row*QPWH-QZWH/2+QPWH;
         UIImageView *item=[[UIImageView alloc]initWithFrame:CGRectMake(X, Y, QZWH, QPWH)];
         item.tag=100+i;
         item.layer.cornerRadius=QZWH/2;
         item.backgroundColor=[UIColor clearColor];
         item.userInteractionEnabled=YES;
         UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
         [item addGestureRecognizer:tap];
         [item setExclusiveTouch:YES];
         [self addSubview:item];
     }
     self.isSuccess=NO;
}

-(void)initLeftRightArr{
    NSInteger leftcount =100;
    NSInteger rightcount=100;
    left=[NSMutableArray array];
    right=[NSMutableArray array];
    for (NSInteger i=0; i<ROW; i++) {
        NSNumber *lefttag=[NSNumber numberWithInteger:leftcount];
        NSNumber *righttag=[NSNumber numberWithInteger:rightcount];
        [left addObject:lefttag];
        [right addObject:righttag];
        leftcount+=Columnssss;
        rightcount+=Columnssss;
        
    }
}



-(void)tapAction:(UITapGestureRecognizer*)tap{
    CGPoint point=[tap locationInView:self];
    [self isContainPoint:point];
    [self judgeSuccessAction];
}


-(void)isContainPoint:(CGPoint)point{
    for(UIView *item in self.subviews){
        BOOL isContBool=CGRectContainsPoint(item.frame, point);
        if (isContBool) {
            if (![self.mArry containsObject:item]) {
                [self.mArry addObject:item];
//                [self downPiece];
               [self setNeedsDisplay];
            }
           
        }
    }
}

-(void)judgeSuccessAction{
    NSMutableArray *blackArr=[[NSMutableArray alloc]init];
    NSMutableArray *whiteArr=[[NSMutableArray alloc]init];
    [self.mArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx%2==0) {
            [blackArr addObject:obj];
            }
        else{
            [whiteArr addObject:obj];}
    }];
    [self success:blackArr isBlack:YES];
    [self success:whiteArr isBlack:NO];
}

-(void)success:(NSMutableArray*)array isBlack:(BOOL)isBlack{
    if (array.count==0) return ;
    NSMutableArray*tagArr=[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    UIView *item=(UIView*)obj;
    [tagArr addObject:[NSNumber numberWithInteger:item.tag]];
}];
    NSArray *newArr =[self comareArray:tagArr];
    NSMutableArray *arrayLeft =[NSMutableArray array];
    NSMutableArray *arrayRight=[NSMutableArray array];
    for (NSNumber *num in newArr) {
        [arrayLeft addObject:num];
        [arrayRight addObject:num];
    }
    [self direction:newArr type:1 isBlack:isBlack];
    
    [self direction:newArr type:Columnssss isBlack:isBlack];
    
    [arrayLeft removeObjectsInArray:left];
    [self direction:arrayLeft type:Columnssss - 1 isBlack:isBlack];
    
    [arrayRight removeObjectsInArray:right];
    [self direction:arrayRight type:Columnssss + 1 isBlack:isBlack];
}

-(void)direction:(NSArray*)array type:(NSInteger)type isBlack:(BOOL)isBlack{
    NSMutableArray *arrr=[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count=1;
        NSNumber *tag =(NSNumber *)obj;
        NSInteger tagInt =tag.integerValue;
        [arrr addObject:tag];
        for (NSInteger i=1; i<array.count; i++) {
            NSNumber *newTag=[NSNumber numberWithInteger:tagInt+type];
            BOOL isContain =[array containsObject:newTag];
            if (isContain) {
                count ++;
                [arrr addObject:newTag];
                if (count>=5) {
                    [self onceSuccess:isBlack];
                    return ;
                }
                tagInt += type;
                
            }else{
                [arrr removeAllObjects];
                break;
            }
        }
    }];
}

-(void)onceSuccess:(BOOL)isBlack{
    if (self.isSuccess) {
        return;
    }
    self.isSuccess=YES;
    NSString *string= isBlack?@"Black Win":@"White Win";
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"END" message:string delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.mArry makeObjectsPerformSelector:@selector(setImage:)withObject:nil];
        [self.mArry removeAllObjects];
        [self setNeedsDisplay];
        self.isSuccess=NO;
    }
}


- (NSArray *)comareArray:(NSArray *)array
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    array = [array sortedArrayUsingComparator:cmptr];
    return array ;
}


-(void)undo{
    UIImageView *item=self.mArry.lastObject;
    item.image=nil;
    
    [self.mArry removeLastObject];
    [self setNeedsDisplay];
    
    
    
    }
    

-(void)replay{
    [self.mArry makeObjectsPerformSelector:@selector(setImage:) withObject:nil];
    [self.mArry removeAllObjects];
    [self setNeedsDisplay];
    self.isSuccess = NO;
}

-(void)drawRect:(CGRect)rect{
    [self.mArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    UIImageView* item=(UIImageView*)obj;
    if (idx%2==0) {
        item.image=[UIImage imageNamed:@"stone1"];
        [item.layer removeAnimationForKey:@"scale"];
    }
    else{
        item.image =[UIImage imageNamed:@"stone2"];
        [item.layer removeAnimationForKey:@"scale"];
    }
}];
    UIImageView* item =self.mArry.lastObject;
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @.8;
    animation.toValue = @1;
    
    animation.duration = .3;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    [item.layer addAnimation:animation forKey:@"scale"];
    
}
-(UIAlertController*)grade{
    UIAlertController *view1=[UIAlertController alertControllerWithTitle:@"jifenb" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [view1 addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDestructive handler:nil]];
    return view1;
}

@end