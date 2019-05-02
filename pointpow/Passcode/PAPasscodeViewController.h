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
- (void)PAPasscodeViewControllerDidResetEmail:(PAPasscodeViewController *)controller didResetEmailPinCode:(NSString*)email;
- (void)PAPasscodeViewControllerDidLoadViewOTP:(PAPasscodeViewController *)controller resendButton:(UIButton*)resendBtn;

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
    UIScrollView *contentView;
    NSInteger phase;
    UILabel *promptLabel;
    UILabel *messageLabel;
    UILabel *forgotLabel;
    UILabel *failedAttemptsLabel;
    UITextField *passcodeTextField;
    UILabel *_digitLabels[6];
    UIImageView *snapshotImageView;
    UIImageView *logoAppImageView;
    
    UITextField *emailTextField;
    UIView *underLineTextFieldView;
    UIButton *sendEmailButton;
    UIImageView *emailImageView;
    
    UITextField *verifyMobileTextField;
    UIImageView *verifyMobileImageView;
    UIView *verifyMobileunderLineTextFieldView;
    
    UITextField *verifyOTPTextField;
    UIImageView *verifyOTPImageView;
    UIView *verifyOTPunderLineTextFieldView;
    
    UILabel *refOTPLabel;
    UIButton *confirmOTPButton;
    UIButton *resendOTPButton;
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
@property (strong) NSString *lockPinMessage;
@property (assign) BOOL centerPosition;
@property (readonly) BOOL forgotPin;
@property (assign) BOOL lockPin;
@property (assign) BOOL lockscreenMode;



- (void)setTitlePasscode:(NSString*)messageError;
- (void)showFailedMessage:(NSString*)messageError;
- (void)showPassCodeSuccess;
- (id)initForAction:(PasscodeAction)action;
- (void)showLockPinCode;
- (void)showMobileOTP:(NSString*)mobile refOTP:(NSString*)ref;

@end
