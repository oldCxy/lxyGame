//
//  AudioVideoSampleBase.m
//  AudioVideoSDK
//
//  Created by tutu on 2019/6/4.
//  Copyright © 2019 tutu. All rights reserved.
//

#import "AudioVideoSampleBase.h"

@interface AudioVideoSampleBase ()

@end

@implementation AudioVideoSampleBase

@synthesize savePathURL = _savePathURL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isAutomaticStop = NO;
        _maxRecordDelay = 0;
    }
    return self;
}

- (void)setOutputFileName:(NSString *)outputFileName{
    _outputFileName = outputFileName;
    
    [self createOutputFile];
}

- (NSFileManager *)audioVideoFileManager{
    if (!_audioVideoFileManager) {
        _audioVideoFileManager = [NSFileManager defaultManager];
    }
    return _audioVideoFileManager;
}

#pragma mark -- 创建保存到路径的文件名
- (void)createOutputFile{
    
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [homePath stringByAppendingPathComponent:self.outputFileName];
    BOOL isDirectory = NO;
    BOOL isDirExist = [self.audioVideoFileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!(isDirExist && isDirectory)) {
        //创建该路径下的文件目录
        BOOL isCreate = [self.audioVideoFileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreate) {
            NSAssert(YES, @"outputFile文件创建失败，请检查");
        }
        NSLog(@"创建文件夹成功，文件路径%@",filePath);
    }
    NSLog(@"文件路径%@",filePath);
}


#pragma mark -- 获取音视频保存的路径
- (NSURL *)getSavePath{
    
    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *savePath = [homePath stringByAppendingPathComponent:self.saveToAlbumName];
    NSString *savePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",self.outputFileName,[self appendSaveNamePath]]];
    _savePathURL = [NSURL fileURLWithPath:savePath];
    
    NSLog(@"file path:%@",savePath);
    
    return _savePathURL;
}

#pragma mark - 拼接音视频文件名称
- (NSString *)appendSaveNamePath
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",timeStr,self.saveSuffixFormat];
    return fileName;
}

#pragma mark -- 清除本地存储的音视频数据数据
- (void)cleanFileCache{
    
    NSError *error;
    NSString *savePath = [NSString stringWithContentsOfURL:self.savePathURL encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSAssert(YES, @"当前路径不存在，请创建再尝试");
    }
    
    if ([self.audioVideoFileManager fileExistsAtPath:savePath]) {
        [self.audioVideoFileManager removeItemAtPath:savePath error:&error];
        //清空url
        _savePathURL = nil;
        if (error) {
            
            NSAssert(YES, @"删除当前存储路径，请检查");
        }
    }
}

@end
