//
//  ViewController.m
//  Example
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import "ViewController.h"
#import "ZHKGestureLockController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) NSString *nameString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHKGestureLockController *gestureLockVC = [[ZHKGestureLockController alloc] init];
    gestureLockVC.style = kGestureLockCheck;
    [self.navigationController presentViewController:gestureLockVC animated:NO completion:nil];
    
//    NSData *data1 = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *data2 = [@"456" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSData *re = [self encrypt:data1 key:data2];
//    
//    NSLog(@"%@", [self data2string:data1]);
//    NSLog(@"%@", [self data2string:data2]);
//    NSLog(@"%@", [self data2string:re]);
    
    
//    AVCaptureDevice *device = nil;//
//    for (AVCaptureDevice *dev in [AVCaptureDevice devices]) {
//        if (dev.position == AVCaptureDevicePositionFront) {
//            device = dev;
//        }
//    }
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
//    [self presentViewController:picker animated:YES completion:nil];
    
    
//    NSLog(@"%@", device);
    
    NSLog(@"name = %@", self.nameString);
}

- (NSString *)nameString {
    if (_nameString == nil) {
        self.nameString = @"name";
    }
    return _nameString;
}

- (void)setName:(NSString *)name {
    if (_nameString != name) {
        _nameString = name;
    }
}

- (NSData *)encrypt:(NSData *)data {
    char *dataP = (char *)[data bytes];
    for (int i = 0; i < data.length; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        *dataP = *(++dataP) ^ 1;
#pragma clang diagnostic pop
    }
    return data;
}

- (NSString *)data2string:(NSData *)data {
    NSMutableString *string = [NSMutableString new];
    char *bytes = (char *)data.bytes;
    for (NSInteger i = 0; i < data.length; ++i) {
        [string appendFormat:@"%d", bytes[i]];
    }
    return [string copy];
}

- (NSData *)encrypt:(NSData *)data key:(NSData *)key {
    char *d = (char *)data.bytes;
    char *k = (char *)key.bytes;
    printf("%s    %s\n", d, k);
    if (data.length >= key.length) {
        for (int i = 0; i < key.length; ++i) {
            d[i] = d[i] ^ k[i];
        }
        return data;
    }else {
        for (int i = 0; i < data.length; ++i) {
            k[i] = d[i] ^ k[i];
        }
        return key;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
