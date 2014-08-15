//
//  ChatMessageTableViewCell.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView  *messageTextView;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

+ (CGFloat)heightForCellWithMessage:(NSString *)message is1To1Chat:(BOOL)is1To1Chat;
- (void)configureCellWithMessage:(NSString *)message is1To1Chat:(BOOL)is1To1Chat;


@property (nonatomic, strong) NSMutableDictionary *currentmessage;

@end
