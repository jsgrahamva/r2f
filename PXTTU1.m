PXTTU1	;ISL/JVS/ESW - Utility Routine-calls from input transforms ;6:07 AM  4 Nov 2015
	;;1.0;PCE PATIENT CARE ENCOUNTER;**106,205,WVEHR,LOCAL**;Aug 12, 1996;Build 1
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
	Q
	; This routines purpose is to hold utilities used by the supporting
	;files for the v files.
	;
ZERO(PXB,PXNAT)	;PXTT TOPICS - Reset the zero node for new ifn's to add
	;                      at option
	;PXB - parameter "^AUTT...(" passed from ENTRY ACTION of the related
	;      Option:
	;             PXTT EDIT EDUCATION TOPICS
	;             PXTT EDIT HEALTH FACTORS
	;             PXTT EDIT IMMUNIZATIONS
	;             PXTT EDIT SKIN TESTS
	;             PXTT EDIT TREATMENT
	;             PXTT EDIT EXAM
	;PXNAT (optional) - a variable to be set temporarily to PXNAT=1 in
	;       ENTRY ACTION, see above, by a developer for setting/editing
	;       a national package.
	;
	D GETSITE Q:$L(PXTDUZ)'=3
	I +$G(PXNAT) S $P(@(PXB_"0)"),U,3)=0
	E  S:(+$P($G(@(PXB_"0)")),U,3)<(PXTDUZ_"000"))!(+$P($G(@(PXB_"0)")),U,3)>(PXTDUZ_"999")) $P(@(PXB_"0)"),U,3)=PXTDUZ_"000"
	Q
	;
	;Begin WorldVistA change
	;WAS;GETSITE S PXTDUZ=+$P($$SITE^VASITE,U,3)
GETSITE	S PXTDUZ=$P($$SITE^VASITE,U,3) S:$G(DUZ("AG"))="V" PXTDUZ=+PXTDUZ
	;End WorldVistA change
	I $L(PXTDUZ)'=3 W !,"Primary site is not 3 character station number! See IRM for setup." Q
	Q
	;
CKNA(PXB)	;Check for duplicat names.
	;PXB - parameter "^AUTT...(" passed by INPUT TRANSFORM of .01 field
	;      of the related file:
	;           HEALTH FACTORS   ; 9999999.64
	;           EDUCATION TOPICS ; 9999999.09
	;           IMMUNIZATION     ; 9999999.14
	;           EXAM             ; 9999999.15
	;           TREATMENT        ; 9999999.17
	;           SKIN TEST        ; 9999999.28
	;PXNAT - optional variable, see above
	N PXD
	S PXD=PXB_"""B"""_","_""""_X_""")"
	;I $D(@PXD),$O(@PXD@(""))<100000 D  Q
	I $D(@PXD) D  Q  ;PX*1.0*205 replaced line above
	.;check for existing national
	.W !,"Duplicate NAMES not allowed." K X
	;additional check for EDUCATION TOPICS
	I $P(PXB,"(")="^AUTTEDT",$F(X,"VA-")=4,'$G(PXNAT) D
	.W !,"NAME cannot start with ""VA-"", reserved for national distribution!" K X
	Q
