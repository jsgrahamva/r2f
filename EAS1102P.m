EAS1102P	;ALB/TDM - EAS*1.0*102 PRE-INSTALL ; 11/9/10 3:46pm
	;;1.0;ENROLLMENT APPLICATION SYSTEM;**102**;MAR 15,2001;Build 3
EN	; Display a message to inform the user that there will be a slight
	; delay when installing the patch.
	;
	N MESS
	S MESS(1)="PRE-INSTALLATION PROCESSING"
	S MESS(2)="---------------------------"
	S MESS(3)="This installation will take some time due to the large size of the file."
	S MESS(4)="Please be patient and allow the process to complete.  Thank you!"
	S MESS(5)=""
	D BMES^XPDUTL(.MESS)
	Q
