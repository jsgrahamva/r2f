PXVP201	;BPIOFO/CLR - Environment routines ; 9/29/14 10:59am
	;;1.0;PCE PATIENT CARE ENCOUNTER;**201**;Aug 12, 1996;Build 41
	;
	Q
PRETRAN	;Load tables
	I $G(DUZ("AG"))'="V" Q
	M @XPDGREF@("PXVMAP")=^XTMP("PXVMAP")
	M @XPDGREF@("PXVCVX")=^XTMP("PXVCVX")
	Q
	;
PRE	;
	N DA,DIK,IEN
	I $G(DUZ("AG"))'="V" Q
	;check that site has no IMMUNIZATION IENs between 1000 and 2000
	I '$D(^AUTTIVIS),($O(^AUTTIMM(1000))<2000) W !,"Invalid IEN in the IMMUNIZATION file - INSTALLATION ABORTED" S XPDABORT=1 Q
	;delete data definitions in V IMMUNIZATION
	F DA=.08,.09,.1,.11,.12,.13,.14,.15 S DIK="^DD(9000010.11,",DA(1)=9000010.11 D ^DIK
	;delete IMM MANUFACTURER
	I $D(^AUTTIMAN) S IEN=0,DIK="^AUTTIMAN(" D
	.F  S IEN=$O(^AUTTIMAN(IEN)) Q:IEN'>0  D
	. . S DA=IEN D ^DIK
	;delete VACCINE INFORMATION STATEMENT
	I $D(^AUTTIVIS) S IEN=0,DIK="^AUTTIVIS(" D
	.F  S IEN=$O(^AUTTIVIS(IEN)) Q:IEN'>0  D
	. . S DA=IEN D ^DIK
	Q
	;
POST	;Post installation
	I $G(DUZ("AG"))'="V" Q  ;do not install in non-VA environments
	N ERRCNT,PXVCPDT,XUMF
	K ^XTMP("PXVMAP"),^XTMP("PXVCVX"),^XTMP("PXVERR")
	M ^XTMP("PXVMAP")=@XPDGREF@("PXVMAP")
	M ^XTMP("PXVCVX")=@XPDGREF@("PXVCVX")
	I '$D(^XTMP("PXVMAP"))!('$D(^XTMP("PXVCVX"))) W !,"Mapping table not loaded - INSTALLATION ABORTED" S XPDQUIT=2 Q
	I '$D(^XTMP("PXVIMM")) M ^XTMP("PXVIMM","PXV")=^AUTTIMM
	S PXVCPDT=$$FMADD^XLFDT(DT,10)
	S ^XTMP("PXVMAP",0)=PXVCPDT_"^"_DT  ;set purge ddt/creation dt
	S ^XTMP("PXVCVX",0)=PXVCPDT_"^"_DT
	S PXVCPDT=$$FMADD^XLFDT(DT,90)
	S ^XTMP("PXVIMM",0)=PXVCPDT_"^"_DT
	D DATA  ;restores backup
	D REINDX  ;re-indexex "B" crossref
	D MAP  ;maps local entries to CVX code using data in ^XTMP("PXVMAP")
	;Selects/updates standard entry for each CVX code
	;using data in ^XTMP("PXVCVX")
	D SELECT
	D REMAIN  ;updates non-standard entries
	D MAIL  ;sends email to installer
	D MVDIAGS^PXVPST01  ;move data in V IMMUNIZATION
	Q
	;
MAP	;map local names to CVX codes
	S XUMF=1
	N PXVZ,PXVIEN,PXVERR,PXVC,I,PXVT
	F I=0:0 S I=$O(^XTMP("PXVMAP",I)) Q:I'>0  D
	. S PXVZ=$G(^XTMP("PXVMAP",I,0))
	. F PXVIEN=0:0 S PXVIEN=$O(^AUTTIMM("B",$P(PXVZ,U),PXVIEN)) Q:PXVIEN=""  D
	. . S PXVC=$S($L($P(PXVZ,U,2))=1:"0"_($P(PXVZ,U,2)),1:$P(PXVZ,U,2))
	. . S PXVT(9999999.14,+PXVIEN_",",.03)=PXVC
	. . D UPDATE^DIE(,"PXVT",,"PXVERR")
	. . I $D(PXVERR) D ERROR(.PXVERR)
	Q
	;
SELECT	;Select standard in local file entries with CVX code
	N I,PXVSTIEN,PXVC,PXVZ,PXVOUT
	F I=0:0 S I=$O(^XTMP("PXVCVX",I)) Q:I=""  D
	. S PXVZ=$G(^XTMP("PXVCVX",I,0))
	. ;handles one overflow line
	. S PXVZ=PXVZ_$G(^XTMP("PXVCVX",I,"OVF",1))
	. S PXVC=$P(PXVZ,U),PXVC=$S($L(PXVC)=1:"0"_PXVC,1:PXVC)
	. I '$D(^AUTTIMM("C",PXVC)) D  Q
	. . S PXVZ="0^"_PXVZ
	. . S PXVOUT=$$STANDARD(PXVZ)
	. ;get ien of standard entry
	. S PXVSTIEN=$$ORDER(PXVC)
	. S PXVZ=PXVSTIEN_"^"_PXVZ
	. S PXVOUT=$$STANDARD(PXVZ)
	Q
	;
ORDER(CVX)	;determines precedence order for record
	; 1:  IEN<1000 & ACTIVE
	; 2:  IEN in local ns & ACTIVE
	; 3:  IEN in remote ns & ACTIVE
	; 4:  IEN<1000 & INACTIVE
	; 5:  IEN in local ns & INACTIVE
	; 6:  IEN in remote ns & INACTIVE
	N I,PXVIEN,PXVORD,PXVST,PXINST,PXVSTIEN,PXVRAY,PXVLAST,PXVSTOP
	N PXVREF,USE
	;initialize precedence order array
	F I=1:1:6 S PXVRAY(I,0)=0  ;set o node
	;get site local number space
	S PXINST=$$SITE^VASITE,PXINST=$P(PXINST,U,3)  ;IA #10112
	;process all existing records with same CVX code
	F PXVIEN=0:0 S PXVIEN=$O(^AUTTIMM("C",CVX,PXVIEN)) Q:PXVIEN=""  D
	. S PXVST=$P(^AUTTIMM(PXVIEN,0),U,7)
	. S PXVORD=""
	. I PXVIEN<1000 S PXVORD=$S(PXVST="":1,1:4)
	. I PXVIEN>(PXINST*1000),PXVIEN<(PXINST+1*1000) S PXVORD=$S(PXVST="":2,1:5)
	. I $G(PXVORD)="" S PXVORD=$S(PXVST="":3,1:6)
	. S PXVRAY(PXVORD,PXVIEN)="",PXVRAY(PXVORD,0)=PXVRAY(PXVORD,0)+1
	;identify national entry
	F PXVORD=1:1:6 D
	. S PXVIEN=$O(PXVRAY(PXVORD,0)) Q:PXVIEN=""
	. I $G(PXVSTIEN),(PXVIEN'=PXVSTIEN) D LOCAL(PXVIEN) Q  ;rename losers
	. I PXVRAY(PXVORD,0)=1 S PXVSTIEN=PXVIEN Q
	. ;resolve ties
	. I PXVRAY(PXVORD,0)>1 D
	. . S USE=-1
	. . S PXVSTOP="9000010.11,""IP"","_PXVIEN_","
	. . F PXVIEN=0:0 S PXVIEN=$O(PXVRAY(PXVORD,PXVIEN)) Q:PXVIEN=""  D
	. . . S PXVREF="^PXRMINDX(9000010.11,""IP"","_PXVIEN_")"
	. . . F I(PXVIEN)=0:1 S PXVREF=$Q(@PXVREF) Q:PXVREF'[PXVSTOP
	. . . I $G(I(PXVIEN))>USE S PXVSTIEN=PXVIEN,USE=I(PXVIEN)
	. . F IEN=0:0 S IEN=$O(I(IEN)) Q:IEN=""  D
	. . . Q:IEN=PXVSTIEN
	. . . D LOCAL(IEN)
	Q PXVSTIEN
	;
STANDARD(PXVZ)	;set up standard record
	;;ien of new entries =1000+CVX code
	;;IEN/O^CVX^NAME^FULLNAME^COMB^STATUS^VIS^^CPT^^ACRONYM^PRODUCTNAME
	N PXV,PXVIEN,PXVERR,PXVT,PXVNM,PXVWP,PXVS
	S XUMF=1
	S (PXVIEN(1),PXV)=+$P(PXVZ,U)
	S PXVC=$P(PXVZ,U,2)  ;CVX code
	I $L(PXVC)=1 S PXVC="0"_PXVC  ;append zero
	;status
	S PXVS=$P(PXVZ,U,6),PXVS=$S(PXVS["Active":"@",1:PXVS)
	;add new one
	I '+$P(PXVZ,U) D
	. S PXVIEN(1)=1000+($P(PXVZ,U,2)),PXV="+1"
	;avoid duplicate name errors
	S PXVNM=$P($G(^AUTTIMM(+$P(PXVZ,U),0)),U)
	I $$UP^XLFSTR($P(PXVZ,U,3))'=$$UP^XLFSTR(PXVNM) D
	. S PXVT(9999999.14,PXV_",",.01)=$$UP^XLFSTR($P(PXVZ,U,3))  ;NAME
	S PXVT(9999999.14,PXV_",",.07)=PXVS  ;INACTIVE FLAG
	S PXVT(9999999.14,PXV_",",.03)=PXVC  ;CVX CODE
	S PXVT(9999999.14,PXV_",",100)="NATIONAL"  ;CLASS
	S PXVT(9999999.14,PXV_",",.2)=$P(PXVZ,U,5)  ;COMBO
	S PXVT(9999999.14,PXV_",",8802)=$P(PXVZ,U,11)  ;ACRONYM
	S PXVT(9999999.14,PXV_",",8803)="Y"  ;SELECTABLE
	D UPDATE^DIE("E","PXVT","PXVIEN","PXVERR")
	I $D(PXVERR) D ERROR(.PXVERR) Q 1
	;CDC FULL VACCINE NAME
	S PXVWP(1)=$P(PXVZ,U,4)
	S PXVWP(1)=$$UP^XLFSTR($E(PXVWP(1),1))_$E(PXVWP(1),2,$L(PXVWP(1)))
	D WP^DIE(9999999.14,PXVIEN(1)_",",2,"K","PXVWP","PXVERR")
	I $D(PXVERR) D ERROR(.PXVERR) Q 1
	;VACCINE INFORMATION STATEMENT
	;CDC PRODUCT NAME
	;CODING SYSTEM->CODE
	D MANY(PXVIEN(1),.PXVZ)
	Q $G(PXVIEN(1))_$S($D(PXVERR):1,1:0)
	;
MANY(IEN,PXVZ)	;populates multiples
	N PXVL,PXVCOL,PXVITEM,I,PXVT,PXVERR,PXVLL,PXVREC
	;VIS
	S PXVL=1,PXVCOL=$$UP^XLFSTR($P(PXVZ,U,7))
	;muliple VIS with same name
	F I=1:1 S PXVITEM=$P(PXVCOL,"|",I) Q:PXVITEM=""  D
	. F PXVREC=0:0 S PXVREC=$O(^AUTTIVIS("B",PXVITEM,PXVREC)) Q:PXVREC=""  D
	. . S PXVT(9999999.144,"?+"_PXVL_","_IEN_",",.01)=PXVREC
	. . S PXVL=PXVL+1
	;CDC PRODUCT NAMES
	S PXVCOL=$$UP^XLFSTR($P(PXVZ,U,12))
	F I=1:1 S PXVITEM=$P(PXVCOL,"|",I) Q:PXVITEM=""  D
	. S PXVT(9999999.145,"?+"_PXVL_","_IEN_",",.01)=PXVITEM
	. S PXVL=PXVL+1
	;CODING SYSTEM
	S PXVCOL="CPT"
	S PXVT(9999999.143,"?+"_PXVL_","_IEN_",",.01)=PXVCOL
	;CPT CODES
	S PXVLL=PXVL,PXVL=PXVL+1,PXVCOL=$P(PXVZ,U,9)
	F I=1:1 S PXVITEM=$P(PXVCOL,"|",I) Q:PXVITEM=""  D
	. S PXVT(9999999.1431,"?+"_PXVL_",?+"_PXVLL_","_IEN_",",.01)=PXVITEM
	. S PXVL=PXVL+1
	D UPDATE^DIE(,"PXVT",,"PXVERR")
	I $D(PXVERR) D ERROR(.PXVERR)
	Q
	;
REMAIN	;
	;loop through file entries with no CVX code
	N PXVIEN,PXVZ
	S PXVIEN=0 F  S PXVIEN=$O(^AUTTIMM(PXVIEN)) Q:PXVIEN'>0  D
	. S PXVZ=$G(^AUTTIMM(+PXVIEN,0))
	. Q:$P($G(^AUTTIMM(PXVIEN,100)),U)="N"
	. D LOCAL(PXVIEN,PXVZ)
	Q
	;
LOCAL(PXVIEN,PXVZ)	;
	N PXVT,PXVERR
	;updates LOCAL record
	I '$D(PXVZ) S PXVZ=$G(^AUTTIMM(PXVIEN,0))
	I $P(PXVZ,U)'["(HISTORICAL)" S PXVT(9999999.14,PXVIEN_",",.01)=$P(PXVZ,U)_" (HISTORICAL)"
	S PXVT(9999999.14,PXVIEN_",",.07)="INACTIVE"
	S PXVT(9999999.14,PXVIEN_",",100)="LOCAL"
	S PXVT(9999999.14,PXVIEN_",",8803)="N"
	D UPDATE^DIE("E","PXVT",,"PXVERR")
	I $D(PXVERR) D ERROR(.PXVERR)
	Q
	;
ERROR(PXVERR)	;
	I '$D(^XTMP("PXVERR",0)) S ^XTMP("PXVERR",0)=$$FMADD^XLFDT(DT,10)_"^"_DT
	S ERRCNT=$S('$D(ERRCNT):1,1:ERRCNT+1)
	S $P(^XTMP("PXVERR",0),U,3)=ERRCNT
	M ^XTMP("PXVERR",ERRCNT)=PXVERR
	Q
	;
MAIL	;
	N PXVTXT,XMSUB,XMTEXT,PXVTXT,XMY,PXVOK,DIFROM
	S PXVOK=$G(^XTMP("PXVERR",0))>0
	S XMSUB="The IMMUNIZATION file update "
	S XMSUB=XMSUB_$S(PXVOK:"FAILED",1:"was SUCCESSFUL")
	S XMTEXT="PXVTXT("
	I PXVOK D
	. S PXVTXT(1)="Errors occurred during the update of the IMMUNIZATION file."
	. S PXVTXT(2)="Details of the errors are stored in ^XTMP(""PXVERR"") for the next 10 days."
	. S PXVTXT(3)="Please contact Product Support for assistance."
	I 'PXVOK D
	. S PXVTXT(1)="The IMMUNIZATION file has been successfully updated."
	S XMY(DUZ)=""
	D ^XMD
	Q
	;
DATA	;deletes data and copies from IMMUNIZATION
	N J,DA,DIK
	S XUMF=1
	I '$D(^XTMP("PXVIMM")) W !,"RESTORE FAILED>>GLOBAL DOES NOT EXIST" Q
	F J=0:0 S J=$O(^AUTTIMM(J)) Q:J'>0  D
	. S DA=J,DIK="^AUTTIMM(" D ^DIK
	S J=-1 F  S J=$O(^XTMP("PXVIMM","PXV",J)) Q:J=""  D
	. M ^AUTTIMM(J)=^XTMP("PXVIMM","PXV",J)
	;M ^AUTTIMM=^XTMP("PXVIMM","PXV")
	Q
REINDX	; re-indexes "B" xref for #.01 and #8801
	N DIK
	K ^AUTTIMM("B")
	S DIK="^AUTTIMM(",DIK(1)=".01^B" D ENALL^DIK
	S DIK="^AUTTIMM(",DIK(1)="8801^B" D ENALL^DIK
	Q
IMMUNIZ	;
	N DIC,DIE,DA,DR,Y,XUMF
	S XUMF=1
	F PXV=0:0 S DIC="^AUTTIMM(",DIC(0)="AEQLN" D ^DIC Q:Y<0  D
	. S DIE="^AUTTIMM(",DR=".03;.07;.2;2;3;4;5;100;8802;8803",DA=+Y D ^DIE
	Q
