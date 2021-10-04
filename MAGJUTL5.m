MAGJUTL5 ;WOIFO/JHC - VistARad RPCs ; 24-Jan-2014 5:19 PM
 ;;3.0;IMAGING;**65,76,101,90,115**;Mar 19, 2002;Build 1;Dec 17, 2010
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
 Q
 ; <*> Version # changes for ISI Rad 1.0.0 -- Jan 2014
GETVER(SVRVER,SVRTVER,ALLOWCL) ;
 ; The Server Version SVRVER is hardcoded to match the Client
 ; so this Routine must be edited/distributed with a new Client
 ; released Client will have the T version (build #) that the server expects
 ;
 ;--- Synchronize the below information with that in MAGJTU4V.
 ;
 ; <*> Edit below line for each new Major &/or Minor &/or Client version
 ;     SVRVER  -- ISI-Major.ISI-Minor.ISIRad-Version  e.g., 1.0.0
 ;     SVRTVER -- contains client build number; define this variable to
 ;       equal the first/lowest client build # that is compatible with
 ;       this KIDS distribution
 ;
 S SVRVER="1.0.0",SVRTVER=32  ; ISI V1.0,  Rad V1 builds 0 and higher
 ;
 S ALLOWCL="|3.0.115|"  ; list of back-compatible prior clients (P115)
 Q
 ;
CHKVER(MAGRY,CLVER,PLC,SVERSION) ;
 ; Input CLVER is the version of the Client
 ;    format: ISI_Major . ISI_Minor . Rad_Version . Build# -- e.g., 1.0.0.38
 ; 3 possible return codes in MAGRY:
 ;   2^n~msg : Client displays a message and continues
 ;   1^1~msg : Client continues without displaying a message
 ;   0^n~msg : Client displays a message then Aborts
 ; PLC returns 2006.1 pointer
 ; SVERSION returns the Server version string
 ;
 S CLVER=$G(CLVER),PLC="",MAGRY=""
 N SV,SBUILD,CV,CBUILD,ALLOWV,SVSTAT
 ; SVERSION = Full Server Version -> (3.0.18.132 or 3.0.18); test has 4, release has 3 parts
 ; SV = Server Version -> (3.0.18); only 1st 3 parts
 ; SBUILD = Server Build # -> define this to correspond to client
 ; CV = Client Version, w/out build #
 ; CBUILD = Client build # alone
 ; ALLOWV = Hard coded string of allowed clients for this KIDS.
 ;
 I $G(DUZ(2)) S PLC=$$PLACE^MAGBAPI(DUZ(2))
 ;  Quit if we don't have a valid DUZ(2) or valid PLACE: ^MAG(2006.1,PLC)
 I 'PLC S MAGRY="0^4~Error verifying Imaging Site (Place) -- Contact Imaging support." Q
 ;
 D GETVER(.SV,.SBUILD,.ALLOWV)
 S CLVER=$P(CLVER,"|")
 S CV=$P(CLVER,".",1,3),CBUILD=+$P(CLVER,".",4)
 ;
 S SVERSION=SV_"."_SBUILD
 ; Check Version differences:
 I (CV'=SV) D  Q
 . I '(ALLOWV[("|"_CV_"|")) D  Q
 . . S MAGRY="0^4~ISI Rad Workstation software version "_CLVER_" is not compatible with the VistA server version "_SVERSION_".  Contact Imaging support. (CNA)"
 . ; Warn the Client, allow to continue
 . E  S MAGRY="2^3~ISI Rad Workstation software version "_CLVER_" is running with VistA server Version "_SVERSION_" --  ISI Rad will Continue, but contact Imaging Support to install Released Version. (RPdif)"
 . Q
 ; Versions are the Same: If build #s are not compatible, warn the Client if needed.
 ; Released Client (of any version) will have a build # in range that the server
 ; expects, so no warning will be displayed.
 I CBUILD<SBUILD D  Q  ; server expects a higher client build #; provide warning
 . S MAGRY="2^3~ISI Rad Workstation software vs. "_CLVER_" is running with VistA server vs. "_SVERSION_" --  ISI Rad will Continue, but some features may not function as expected. Contact Imaging Support to install updated client software.  (Tdif-1)"
 . Q
 ; Client and Server Versions are compatible
 S MAGRY="1^1~Version Check OK. Server: "_SVERSION_" Client: "_CLVER Q
 Q
 ;
P32STOP(RET) ; logic to indicate P32 should no longer function, once the RELEASED P76 is installed
 ; This is invoked from magjutl3, P76 version, if a P32 client is launched
 ; RET=1/0 ^ text -- 0 = OK to run P32; 1 = Not OK
 S RET="1^P32 support over"
 Q
END ;
