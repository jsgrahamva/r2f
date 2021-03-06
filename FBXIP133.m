FBXIP133	;DSS/BPD - PATCH INSTALL ROUTINE;7:02 AM  26 Mar 2014
	;;3.5;FEE BASIS;**133,WVEHR,LOCAL**;APR 04, 2011;Build 3
	;;Modified from FOIA VistA
	;
	; Copyright 2015 WorldVistA.
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	;DBIA# Supported Reference
	;----- --------------------------------
	;10141 $$VERSION^XPDUTL
	;10141 MES^XPDUTL
	;
	Q
PRE	;PATCH 133 PRE-INSTALL ROUTINE
	; DELETE THE FOLLOWING FIELDS FROM THE 162 FILE SO THEY CAN BE MOVED TO A DIFFERENT SUB-FILE
	; VIA INSTALLATION OF THE FILE IN THE KID BUILD
	;DELETE FIELD #58 - ATTENDING PROV NAME, DELETE FIELD #59 - ATTENDING PROV NPI
	;DELETE FIELD #60 - ATTENDING PROV TAXONOMY CODE, DELETE FIELD #61 - OPERATING PROV NAME
	;DELETE FIELD #62 - OPERATING PROV NPI, DELETE FIELD #63 - RENDERING PROV NAME
	;DELETE FIELD #64 - RENDERING PROV NPI, DELETE FIELD #65 - RENDERING PROV TAXONOMY CODE
	;DELETE FIELD #66 - SERVICING PROV NAME, DELETE FIELD #67 - SERVICING PROV NPI
	;DELETE FIELD #68 - REFERRING PROV NAME, DELETE FIELD #69 - REFERRING PROV NPI
	;DELETE FIELD #76 - SERVICING FACILITY ADDRESS, DELETE FIELD #77 - SERVICING FACILITY CITY
	;DELETE FIELD #78 - SERVICING FACILITY STATE, DELETE FIELD #79 - SERVICING FACILITY ZIP
	;Begin WorldVistA change
	S X="DSICFM06" X ^%ZOSF("TEST") Q:'$T
	;End WorldVistA change
	N FLD
	F FLD=58,59,60,61,62,63,64,65,66,67,68,69,76,77,78,79 D
	.I $$VFILE^DSICFM06(,162.02,1)>0,$$VFIELD^DSICFM06(,162.02,FLD,1)>0 D
	..N DA,DD,DO,DIK S DA(1)=162.02,DA=FLD,DIK="^DD(162.02," D ^DIK
	..Q
	S ^TMP("FBXIP133",$J)=$$PATCH^XPDUTL("FB*3.5*133")
	Q
DATADEL	;
	N FBPAT,FBVEN,FBDAT,CNT S FBPAT=0,FBVEN=0,FBDAT=0,CNT=1,FBRET=$NA(^TMP("FBXIP133",$J))
	F  S FBPAT=$O(^FBAAC(FBPAT)) Q:'FBPAT  D
	.S FBVEN=0 F  S FBVEN=$O(^FBAAC(FBPAT,1,FBVEN)) Q:'FBVEN  D
	..S FBDAT=0 F  S FBDAT=$O(^FBAAC(FBPAT,1,FBVEN,1,FBDAT)) Q:'FBDAT  D
	...I $D(^FBAAC(FBPAT,1,FBVEN,1,FBDAT,2)) K ^FBAAC(FBPAT,1,FBVEN,1,FBDAT,2) S @FBRET@(CNT)="KILLED ^FBAAC("_FBPAT_",1,"_FBVEN_",1,"_FBDAT_",2)",CNT=CNT+1
	...I $D(^FBAAC(FBPAT,1,FBVEN,1,FBDAT,4)) K ^FBAAC(FBPAT,1,FBVEN,1,FBDAT,4) S @FBRET@(CNT)="KILLED ^FBAAC("_FBPAT_",1,"_FBVEN_",1,"_FBDAT_",4)",CNT=CNT+1
	Q
POST	;
	;
	;Begin WorldVistA change
	S X="DSICXPDU" X ^%ZOSF("TEST") Q:'$T
	;End WorldVistA change
	;Queue off visit date fix
	N M S M(1)=" This part of the post-install will be queued, but may "
	S M(2)=" take some time to run. It loops through the FEE BASIS PAYMENT "
	S M(3)=" file and removes any data that existed in the fields being moved "
	S M(4)=" to a different location within FEE BASIS PAYMENT."
	S M(5)=" The fields being deleted and re-added in a new location are: "
	S M(6)=" Fields: 59,60,61,62,63,64,65,66,67,68,69,76,77,78,79"
	D MES^DSICXPDU(.M,1)
	I ^TMP("FBXIP133",$J)=0 D TASK ; Task off repairing Visit dates
	;
	K ^TMP("FBXIP133",$J)
	Q
TASK	; Create a queued task to perform visit date fix caused
	; in P57 when undeleting transactions
	N X,Y,Z,ZTSK,ZTIO,ZTRTN,ZTDTH,ZTSAVE,ZTDESC
	I '$D(XPDNM) D  Q:'X
	.I $G(DUZ)<.5 W !!,"Please sign on properly through the Kernel" S X=0
	.E  D HOME^%ZIS,DT^DICRW S X=1
	.Q
	S ZTIO="",ZTDTH=$H,ZTRTN="DATADEL^FBXIP133",ZTDESC="FB PATCH 133 POST-INSTALL"
	D ^%ZTLOAD S X="Patch 133 post-install successfully queued, task# "_$G(ZTSK)
	I $G(ZTSK) D MSG(X)
	I '$G(ZTSK) D MSG("Could not queue the Post-Install!"),MSG("Enter a Remedy ticket.")
	Q
MSG(X)	;
	S X="   >> "_X_" <<"
	D MES^DSICXPDU(X,1)
	Q
