//
//  PAPasscodeViewController.h
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PasscodeActionSet,
    PasscodeActionEnter,
    PasscodeActionChange
} PasscodeAction;

@class PAPasscodeViewController;

@protocol PAPasscodeViewControllerDelegate <NSObject>

@optional
- (void)PAPasscodeViewControllerDidEnterPasscodeResult:(PAPasscodeViewController *)controller didEnterPassCode:(NSString*)passcode;
- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidEnterAlternativePasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller didSetPassCode:(NSString*)passcode;
- (void)PAPasscodeViewController:(PAPasscodeViewController *)controller didFailToEnterPasscode:(NSInteger)attempts;

@end

@interface PAPasscodeViewController : UIViewController <UITextFieldDelegate> {
    NSArray *_installedConstraints;
    UIView *_inputPanel;
    NSLayoutConstraint *_keyboardHeightConstraint;
    UIView *contentView;
    NSInteger phase;
    UILabel *promptLabel;
    UILabel *messageLabel;
    UIView *_failedAttemptsView;
    
    UITextField *passcodeTextField;
    UILabel *_digitLabels[6];
    UIImageView *snapshotImageView;
    UIImageView *logoAppImageView;
}

@property (strong) UIView *backgroundView;
@property (readonly) PasscodeAction action;
@property (weak) id<PAPasscodeViewControllerDelegate> delegate;
@property (strong) NSString *alternativePasscode;
@property (strong) NSString *passcode;
@property (assign) BOOL simple;
@property (assign) NSInteger failedAttempts;
@property (strong) NSString *enterPrompt;
@property (strong) NSString *confirmPrompt;
@property (strong) NSString *changePrompt;
@property (strong) NSString *message;
@property (assign) BOOL centerPosition;

- (void)setTitlePasscode:(NSString*)messageError;
- (void)showFailedMessage:(NSString*)messageError;
- (void)showPassCodeSuccess;
- (id)initForAction:(PasscodeAction)action;

@end
