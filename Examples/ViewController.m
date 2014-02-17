//
//  ViewController.m
//  LKCodingObject
//
//  Created by Hiroshi Hashiguchi on 2014/01/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "ViewController.h"
#import "SampleObject.h"
#import "SampleObjectSub.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SampleObject* obj = SampleObject.new;
    obj.stringValue = @"Hello";
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    SampleObject* obj2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", obj2.stringValue);

    
    SampleObjectSub* objS = SampleObjectSub.new;
    objS.stringValue = @"Hello-Sub";
    NSData* dataS = [NSKeyedArchiver archivedDataWithRootObject:objS];
    SampleObject* objS2 = [NSKeyedUnarchiver unarchiveObjectWithData:dataS];
    NSLog(@"%@", objS2.stringValue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
