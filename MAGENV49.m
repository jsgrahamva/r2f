MAGENV49 ;WOIFO/MLH - Environment check routine to abort if Rad Patch 47 not installed ; 08/17/2010 13:21
 ;;3.0;IMAGING;**49**;Mar 19, 2002;Build 2;Sep 07, 2010
 ;; Per VHA Directive 2004-038, this routine should not be modified.
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
ENV ; environment check - don't let them install if the new Radiology
 ; event drivers are not available (because they haven't installed
 ; Radiology Patch 47)
 ; Abort ONLY during installation, not during load
 ; 
 ; Expects:  XPDENV   Kernel variable set 0 if this is load phase
 ;                                        1 if this is install phase
 ;
 N OK,P101,ROU,X
 K XPDABORT ; -- variable checked by Kernel, aborts install if defined
 ;
 D  Q:$D(XPDABORT)  ; are new event drivers available (i.e., Rad Patch 47 installed)?
 . S OK=1
 . S:'$D(^ORD(101,"B","RA CANCEL 2.4")) OK=0
 . S:'$D(^ORD(101,"B","RA EXAMINED 2.4")) OK=0
 . S:'$D(^ORD(101,"B","RA REG 2.4")) OK=0
 . Q:OK  ; yes, proceed
 . ;
 . ;  no, abort the installation (but not the load)
 . W !,"**********   A T T E N T I O N   **********"
 . W !,"You must install Radiology V5 Patch 47 before"
 . W !,"installing Imaging V3 Patch 49."
 . ;
 . I $G(XPDENV)=1 D  Q  ; abort during Install Package(s)
 . . W !!,"Aborting...",! S XPDABORT=2 ; don't kill transport global
 . . Q
 . ;
 . ; don't abort during Load a Distribution
 . W !!,"Continuing...",!
 . Q
 Q
 ;
