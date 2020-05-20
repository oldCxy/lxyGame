//
//  VideoRecordSampleBase.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/14.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "VideoRecordSampleBase.h"

@implementation VideoRecordSampleBase

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.outputFileName = @"VideoFile";
        self.saveSuffixFormat = @"mp4";
    }
    return self;
}

@end
