XVSC ; Paideia/SMH - VPE warn of a global kill;2017-08-16  10:56 AM; 10/17/09 11:16pm
 ;;14.1;VICTORY PROG ENVIRONMENT;;Aug 16, 2017
 ; (c) 2010-2016 Sam Habiel
 ;
 Q:$G(XVVWARN)="QWIK"
 N HLD
 S HLD=$$ALLCAPS^XVEMKU(XVVSHC)
 I HLD["K",HLD["^" DO
 . N FLAGG S FLAGG="GLB"
 . D KILLCHK^XVEMKU(HLD)
 QUIT
