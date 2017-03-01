//
//  ViewController.m
//  PushClientSDKDemo
//
//  Created by jeasonyoung on 2017/2/28.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#import "PushClientSDK.h"

NSString * const PUSH_HOST = @"http://162.16.4.36:8080";
NSString * const PUSH_ACCOUNT = @"test";
NSString * const PUSH_TOKEN = @"123456";


@interface ViewController ()

@property(strong, nonatomic)UIView *tagView;
@property(strong, nonatomic)UILabel *lbTag;
@property(strong, nonatomic)UITextView *tvTag;

@property(strong, nonatomic)UIView *btnView;
@property(strong, nonatomic)UIButton *btnAddTag;
@property(strong, nonatomic)UIButton *btnClearTag;

@property(strong, nonatomic)UIButton *btnStart;
@property(strong, nonatomic)UIButton *btnStop;

@property(strong,nonatomic)UITextView *tvPublish;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self loadSubViews];
    [self updateViewConstraints];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onStartClicked{
    NSString *deviceId = @"test-app-001";
    NSData *deviceToken = [deviceId dataUsingEncoding:NSUTF8StringEncoding];
    
    PushClientSDK *sdk = [PushClientSDK sharedInstance];
    [sdk startHost:PUSH_HOST andAccount:PUSH_ACCOUNT andPassword:PUSH_TOKEN withDeviceToken:deviceToken];
}

-(void)onStopClicked{
    PushClientSDK *sdk = [PushClientSDK sharedInstance];
    [sdk close];
}


-(void)onAddTagClicked{
    NSString *tag = self.tvTag.text;
    if(!tag || !tag.length) return;
    
    PushClientSDK *sdk = [PushClientSDK sharedInstance];
    [sdk addOrChangedTag:tag];
}

-(void)onClearTagClicked{
    PushClientSDK *sdk = [PushClientSDK sharedInstance];
    [sdk clearTag];
}


#pragma mark -- layout
//
-(void)loadSubViews{
    self.title = @"socket-推送Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self.view addSubview:self.btnView];
    [self.btnView addSubview:self.btnStart];
    [self.btnView addSubview:self.btnAddTag];
    [self.btnView addSubview:self.btnClearTag];
    [self.btnView addSubview:self.btnStop];
    //
    [self.btnView addSubview:self.tagView];
    [self.tagView addSubview:self.lbTag];
    [self.tagView addSubview:self.tvTag];
    //
    [self.view addSubview:self.tvPublish];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    //
    int padding = 10, height = 30;
    //按钮View布局约束
    self.btnView.backgroundColor = [UIColor yellowColor];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding * 2);
        
        make.left.equalTo(self.view.mas_left).with.offset(padding);
        make.right.equalTo(self.view.mas_right).with.offset(-padding);
        
        make.bottom.equalTo(self.tagView).with.offset(padding);
    }];
   //1.1 启动按钮
    [self.btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_top).with.offset(padding);

        make.left.equalTo(self.btnView.mas_left).with.offset(padding);
        make.right.equalTo(self.btnStop.mas_left).with.offset(-padding);
        
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(self.btnStop);
    }];
    //1.2 关闭按钮
    [self.btnStop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_top).with.offset(padding);
        
        make.left.equalTo(self.btnStart.mas_right).with.offset(padding);
        make.right.equalTo(self.btnView.mas_right).with.offset(-padding);
        
        make.height.mas_equalTo(height);
        make.width.equalTo(self.btnStart);
    }];
    
    //2.1 绑定按钮
    [self.btnAddTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnStart.mas_bottom).with.offset(padding);
        
        make.left.equalTo(self.btnView.mas_left).with.offset(padding);
        make.right.equalTo(self.btnClearTag.mas_left).with.offset(-padding);
        
        make.height.mas_equalTo(height);
        make.width.equalTo(self.btnClearTag);
    }];
    //2.2 清除绑定
    [self.btnClearTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnStop.mas_bottom).with.offset(padding);
        
        make.left.equalTo(self.btnAddTag.mas_right).with.offset(padding);
        make.right.equalTo(self.btnView.mas_right).with.offset(-padding);
        
        make.height.mas_equalTo(height);
        make.width.equalTo(self.btnAddTag);
    }];
    
    //3.tagView
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnAddTag.mas_bottom).with.offset(padding);
        
        make.left.equalTo(self.btnView.mas_left).with.offset(padding);
        make.right.equalTo(self.btnView.mas_right).with.offset(-padding);
        
        make.height.mas_equalTo(self.lbTag).with.offset(padding);
    }];
    //3.1 lbTag
    self.lbTag.backgroundColor = [UIColor redColor];
    [self.lbTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_top).with.offset(padding/2);
        make.left.equalTo(self.tagView.mas_left).with.offset(padding/2);
    }];
    //3.2 tvTag
    int tv_padding = 2;
    [self.tvTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_top).with.offset(tv_padding);
        make.bottom.equalTo(self.tagView.mas_bottom).with.offset(-tv_padding);
        
        make.left.equalTo(self.lbTag.mas_right).with.offset(padding/2);
        make.right.equalTo(self.tagView.mas_right).with.offset(-tv_padding);
    }];
    //4
    [self.tvPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_bottom).with.offset(padding);
        
        make.left.equalTo(self.view.mas_left).with.offset(padding);
        make.right.equalTo(self.view.mas_right).with.offset(-padding);
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding);
    }];
}

#pragma mark -- getter

-(UIView *)tagView{
    if(!_tagView){
        _tagView = [[UIView alloc] init];
        [self buildViewCornerRadius:_tagView];
    }
    return _tagView;
}

-(UILabel *)lbTag{
    if(!_lbTag){
        _lbTag = [[UILabel alloc] init];
        _lbTag.text = @"绑定标签:";
        _lbTag.font = [UIFont systemFontOfSize:16];
        _lbTag.textColor = [UIColor brownColor];
        _lbTag.textAlignment = NSTextAlignmentLeft;
        _lbTag.frame = CGRectMake(0, 0, 100, 30);
    }
    return _lbTag;
}

-(UITextView *)tvTag{
    if(!_tvTag){
        _tvTag = [[UITextView alloc] init];
        [self buildViewCornerRadius:_tvTag];
    }
    return _tvTag;
}

-(UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc] init];
        [self buildViewCornerRadius:_btnView];
    }
    return _btnView;
}

-(UIButton *)btnStart{
    if(!_btnStart){
        _btnStart = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnStart setTitle:@"启动socket" forState:UIControlStateNormal];
        [self buildViewCornerRadius:_btnStart];
        [_btnStart addTarget:self action:@selector(onStartClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnStart;
}

-(UIButton *)btnAddTag{
    if(!_btnAddTag){
        _btnAddTag = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnAddTag setTitle:@"绑定设备标签" forState:UIControlStateNormal];
        [self buildViewCornerRadius:_btnAddTag];
        [_btnAddTag addTarget:self action:@selector(onAddTagClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddTag;
}

-(UIButton *)btnClearTag{
    if(!_btnClearTag){
        _btnClearTag = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnClearTag setTitle:@"解绑设备标签" forState:UIControlStateNormal];
        [self buildViewCornerRadius:_btnClearTag];
        [_btnClearTag addTarget:self action:@selector(onClearTagClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClearTag;
}

-(UIButton *)btnStop{
    if(!_btnStop){
        _btnStop = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnStop setTitle:@"关闭socket" forState:UIControlStateNormal];
        [self buildViewCornerRadius:_btnStop];
        [_btnStop addTarget:self action:@selector(onStopClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnStop;
}

-(UITextView *)tvPublish{
    if(!_tvPublish){
        _tvPublish = [[UITextView alloc] init];
        _tvPublish.text = @"接收到的推送消息...";
        [_tvPublish setEditable:NO];
        [self buildViewCornerRadius:_tvPublish];
    }
    return _tvPublish;
}

-(void)buildViewCornerRadius:(UIView *)view{
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = .5;
    view.layer.borderColor = [UIColor blueColor].CGColor;
}

@end
