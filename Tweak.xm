@interface AMCenter: NSObject
{
	id _lastAlert;
	_Bool _DNDState;
	UIView *_callView;
	UIImageView *leftRotatingView;
	UIImageView *rightRotatingView;
	UILabel *statusLabel;
	UILabel *statusHeader;
	NSTimer *_callTimer;
	NSMutableArray *entries;
	int messagePlayingCount;
	NSMutableString *passcodeString;
	int incorrectPasscodesCount;
	int ringerStateBeforeAnswering;
	UILabel *sneakInfoLabel;
	NSString *_downloadedPath;
	NSMutableDictionary *_currentCallDictionary;
	_Bool shouldDeclineCall;
}

+ (id)sharedInstance;
@property(nonatomic) _Bool shouldDeclineCall; // @synthesize shouldDeclineCall;
- (void)handleCallStatusChangedWithCall:(id)arg1;
- (id)formattedNameFromName:(id)arg1;
- (id)formattedNumberFromNumber:(id)arg1;
- (void)setLastCallAsMissed;
- (id)cleanedNumber:(id)arg1;
- (void *)existingPersonForAddress:(id)arg1;
- (_Bool)stopSpeaking;
- (id)completionHandler;
- (id)returnedController;
- (id)alertManager;
- (void)resumeInCallServiceForActualCallTakeover;
- (void)requestRemoteViewService;
- (void)autoAnswerCall;
- (void)updateStatusBarString:(id)arg1;
- (void)checkForCallStartup:(id)arg1;
- (id)adapter;
- (void)setNewMessageCount:(int)arg1;
- (void)speakString:(id)arg1 language:(id)arg2 voice:(id)arg3;
- (void)speechSynthesizer:(id)arg1 didPauseSpeakingRequest:(id)arg2;
- (void)speechSynthesizerSaidDidFinishSpeaking;
- (void)playNextAudioMessage;
- (void)audioPlayerDidFinishPlaying:(id)arg1 successfully:(_Bool)arg2;
- (id)splitString:(id)arg1;
- (void)playNextMessage;
- (void)playWelcomeMessage;
- (void)playIncorrectPasscodeMessage;
- (void)playPasscodeMessage;
- (void)playDeleteWarning;
- (void)playAllMessagesDeleted;
- (void)playCurrentMessageOptions;
- (void)playCurrentMessageDeleted;
- (void)playAdvancedCommandsIntro;
- (id)advancedCommandsString;
- (void)playSendingLocation;
- (void)testLocation;
- (void)playRestartingSpringBoard;
- (void)playRebooting;
- (void)didReceiveKeypress:(id)arg1;
- (_Bool)isSpeaking;
- (_Bool)DNDState;
- (id)init;
- (id)appIcon;
- (void)dismissWindow:(id)arg1;
- (void)takeOverCurrentCall;
- (void)pickSpeakerRoute;
- (void)pickHandsetRoute;
- (void)pickRouteWithUID:(id)arg1;
- (void)listenToCaller:(id)arg1;
- (void)declineCurrentCall;
- (id)statusHeader;
- (id)statusLabel;
- (void)stopAnimation;
- (void)startAnimation;
- (id)callWindow;
- (id)speechSynthesizer;
- (id)callerName;
- (id)statusString;
- (id)callImageWithColor:(id)arg1 glyph:(id)arg2;
- (id)sneakButton;
- (_Bool)autoAnswering;
- (_Bool)callAutoAnswered;
- (int)numberOfUnreadMessages;
- (int)numberOfMessages;
- (void)getEntries;
- (void)stateService:(id)arg1 didReceiveDoNotDisturbStateUpdate:(id)arg2;
- (void)setDNDStateInternal:(_Bool)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

@interface TUCallCenter: NSObject
+(id)sharedInstance;
-(NSArray *)currentCalls;
@end

@interface TUProxyCall: NSObject
-(NSString *)audioCategory;
-(NSString *)callerNameFromNetwork;
@end



%hook AMCenter
-(void)autoAnswerCall {
	NSArray *currentCalls = [[NSClassFromString(@"TUCallCenter") sharedInstance] currentCalls];
	TUProxyCall *currentCall = [currentCalls lastObject];
	NSString *callInfo = [currentCall valueForKey:@"description"];

	if(![callInfo containsString:@"p=com.apple.coretelephony"]) {
		HBLogDebug(@"application is third party... Do nothing");
		return;
	}
	%orig;
}
%end

%ctor {
	HBLogDebug(@"loaded");
}