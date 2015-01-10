//
//  ViewController.m
//  oc-gcd-usedemo
//
//  Created by apple on 15-1-10.
//  Copyright (c) 2015年 thinker. All rights reserved.
//
//reference website:http://blog.csdn.net/totogo2010/article/details/8016129
//https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md



#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNetPictrue ];
    
    
//    [self test_dispatch_async];
//    [self test_dispatch_barrier_async];
    [self test_dispatch_group_async];
}




-(void) showNetPictrue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSLog(@"do block picture");
        
        NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    });
}

// dispatch_async的使用方法
-(void) test_dispatch_async {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"thread do time－consuming thing");
        [NSThread sleepForTimeInterval:4];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"finish task first ");
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"finish task second ");
        [NSThread sleepForTimeInterval:2];
    });
}

// dispatch_barries_async的使用方法
-(void) test_dispatch_barrier_async {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_barrier_async.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"finish task first ");
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"finish task second ");
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"finish task third ");
    });
}

// dispatch_barries_async的使用方法
-(void) test_dispatch_group_async {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_group_async.test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"finish task first ");
    });
    dispatch_group_async(group,queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"finish task second ");
    });
    dispatch_group_async(group,queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"finish task third ");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
