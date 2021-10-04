FBXIP118	;ALB/BP-PATCH INSTALL ROUTINE ; 1/7/10 9:03pm
	;;3.5;FEE BASIS;**118**;JAN 30, 1995;Build 14
	Q
	;
PRE	;PRE-INSTALL ENTRY POINT
	N DIK,DA,FBMLNM,FBMLIEN
	S FBMLNM=""
	F  S FBMLNM=$O(^FB(162.98,"B",FBMLNM)) Q:'FBMLNM  D
	. I FBMLNM["2010-" D
	.. S FBMLIEN=0
	.. S FBMLIEN=$O(^FB(162.98,"B",FBMLNM,FBMLIEN))
	.. S DIK="^FB(162.98,",DA=FBMLIEN
	.. D ^DIK
	Q
POST	; post-install entry point
	; create KIDS checkpoints with call backs
	N FBX
	F FBX="EN" D
	. S Y=$$NEWCP^XPDUTL(FBX,FBX_"^FBXIP118")
	. I 'Y D BMES^XPDUTL("ERROR Creating "_FBX_" Checkpoint.")
	Q
	;
EN	; Begin Post-Install
	D CF ;Add Conv factors
	Q
CF	; add conversion factors for calendar year 2010 RBRVS fee schedule
	; File 162.99 is being updated in the post install because the Fee
	; Basis software examines this file to determine the latest available
	; fee schedule. By doing this at the end of the patch installation,
	; users can continue to use the payment options during the install.
	D BMES^XPDUTL("  Filing conversion factor for RBRVS 2010 AND 2011 fee schedule.")
	N DD,DO,DA,DIE,DR,X,Y
	S DA(1)=0 F  S DA(1)=$O(^FB(162.99,DA(1))) Q:'DA(1)  D
	. S DA=$O(^FB(162.99,DA(1),"CY","B",2010,0))
	. I DA'>0 D  Q:DA'>0
	. . S DIC="^FB(162.99,"_DA(1)_",""CY"",",DIC(0)="L",DIC("P")="162.991A",DLAYGO=162.991
	. . S X=2010
	. . K DD,DO D FILE^DICN
	. . K DIC,DLAYGO
	. . S DA=+Y
	. ;
	. S DIE="^FB(162.99,"_DA(1)_",""CY"","
	. S DR=".02///"_$S(DA(1)=1:21.114,1:36.8729)
	. D ^DIE
	S DA(1)=0 F  S DA(1)=$O(^FB(162.99,DA(1))) Q:'DA(1)  D
	. S DA=$O(^FB(162.99,DA(1),"CY","B",2011,0))
	. I DA'>0 D  Q:DA'>0
	. . S DIC="^FB(162.99,"_DA(1)_",""CY"",",DIC(0)="L",DIC("P")="162.991A",DLAYGO=162.991
	. . S X=2011
	. . K DD,DO D FILE^DICN
	. . K DIC,DLAYGO
	. . S DA=+Y
	. ;
	. S DIE="^FB(162.99,"_DA(1)_",""CY"","
	. S DR=".02///"_$S(DA(1)=1:15.8085,1:33.9764)
	. D ^DIE
	Q
	;FBXIP118
