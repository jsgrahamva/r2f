ECX3P152	;ALB/DE - ECX*3.0*152 Post-Init RTN;9/22/14
	;;3.0;DSS EXTRACTS;**152**;Dec 22, 1997;Build 3
	;
	;Post-init routine updating current entries in
	;the NATIONAL CLINIC (#728.441) file
	;
	Q
	;
EN	;routine entry point
	D UPDATE     ;change name to existing Clinic codes
	Q
	;
UPDATE	;changing short description of existing clinic
	N ECXCODE,ECXDESC,ECXIEN,DIE,DA,DR,ECXI,ECXREC
	D BMES^XPDUTL(">>>Updating entry in the NATIONAL CLINIC (728.441) file..")
	F ECXI=1:1 S ECXREC=$P($T(UPDCLIN+ECXI),";;",2) Q:ECXREC="QUIT"  D
	 .S ECXCODE=$P(ECXREC,"^"),ECXDESC=$P(ECXREC,"^",2)
	 .S ECXIEN=$$FIND1^DIC(728.441,"","X",ECXCODE,"","","ERR")
	 .I 'ECXIEN D  Q
	 ..D BMES^XPDUTL(">>>...Unable to update "_ECXCODE_" - "_$P(ECXREC,U,2)_".")
	 ..D BMES^XPDUTL(">>>...Contact support for assistance")
	 .N FDA
	 .S FDA(728.441,ECXIEN_",",1)=ECXDESC
	 .D FILE^DIE(,"FDA","ECXERR")
	 .D BMES^XPDUTL(">>>..."_ECXCODE_" - "_$P(ECXREC,U,2)_" updated")
	I '$D(ECXERR) D BMES^XPDUTL("Update complete") Q  ;quit here if update was successful
	D BMES^XPDUTL("***Errors occurred during install. Please check ECXERR(""DIERR"") for errors***")
	Q  ;quit here if errors occurred during update
	;
UPDCLIN	;Contains the NATIONAL CLINIC entry description to be updated
	;;NASL^ALS Regional Facility
	;;RHTC^Rehab PT (non Home Telehealth)
	;;VITL^VITAL Initiative Program
	;;WCNC^CHAR4 COUNCIL
	;;WCQC^Women's Telehealth Program
	;;CDBC^CHAR4 COUNCIL
	;;CDDC^CHAR4 COUNCIL
	;;CDEC^CHAR4 COUNCIL
	;;CDFC^CHAR4 COUNCIL
	;;CDGC^CHAR4 COUNCIL
	;;CDHC^CHAR4 COUNCIL
	;;CDJC^CHAR4 COUNCIL
	;;CDKC^CHAR4 COUNCIL
	;;CDLC^CHAR4 COUNCIL
	;;CDMC^CHAR4 COUNCIL
	;;CDPC^CHAR4 COUNCIL
	;;CDQC^CHAR4 COUNCIL
	;;CDRC^CHAR4 COUNCIL
	;;CDSC^CHAR4 COUNCIL
	;;CDTC^CHAR4 COUNCIL
	;;CDUC^CHAR4 COUNCIL
	;;CDVC^CHAR4 COUNCIL
	;;CDWC^CHAR4 COUNCIL
	;;CGAC^CHAR4 COUNCIL
	;;CGDC^CHAR4 COUNCIL
	;;CGEC^CHAR4 COUNCIL
	;;CGFC^CHAR4 COUNCIL
	;;CGHC^CHAR4 COUNCIL
	;;CGJC^CHAR4 COUNCIL
	;;CGKC^CHAR4 COUNCIL
	;;CGLC^CHAR4 COUNCIL
	;;CGNC^CHAR4 COUNCIL
	;;CGPC^CHAR4 COUNCIL
	;;CGQC^CHAR4 COUNCIL
	;;CGSC^CHAR4 COUNCIL
	;;CGTC^CHAR4 COUNCIL
	;;CGUC^CHAR4 COUNCIL
	;;CGVC^CHAR4 COUNCIL
	;;CGWC^CHAR4 COUNCIL
	;;CNSF^CHAR4 COUNCIL
	;;CNSG^CHAR4 COUNCIL
	;;CNSI^CHAR4 COUNCIL
	;;CNSP^CHAR4 COUNCIL
	;;CNSQ^CHAR4 COUNCIL
	;;CNSU^CHAR4 COUNCIL
	;;CNSW^CHAR4 COUNCIL
	;;CNSX^CHAR4 COUNCIL
	;;CNSY^CHAR4 COUNCIL
	;;COLL^CHAR4 COUNCIL
	;;DEAC^CHAR4 COUNCIL
	;;DEBC^CHAR4 COUNCIL
	;;DEDC^CHAR4 COUNCIL
	;;DEEC^CHAR4 COUNCIL
	;;DEFC^CHAR4 COUNCIL
	;;DEGC^CHAR4 COUNCIL
	;;DEHC^CHAR4 COUNCIL
	;;DELC^CHAR4 COUNCIL
	;;DEMC^CHAR4 COUNCIL
	;;DEMT^CHAR4 COUNCIL
	;;DENC^CHAR4 COUNCIL
	;;DEPC^CHAR4 COUNCIL
	;;DEPS^CHAR4 COUNCIL
	;;DEQC^CHAR4 COUNCIL
	;;DERC^CHAR4 COUNCIL
	;;DESC^CHAR4 COUNCIL
	;;DETC^CHAR4 COUNCIL
	;;DEUC^CHAR4 COUNCIL
	;;DEVC^CHAR4 COUNCIL
	;;DEWC^CHAR4 COUNCIL
	;;DMAC^CHAR4 COUNCIL
	;;DMBC^CHAR4 COUNCIL
	;;DMDC^CHAR4 COUNCIL
	;;DMEC^CHAR4 COUNCIL
	;;DMFC^CHAR4 COUNCIL
	;;DMGC^CHAR4 COUNCIL
	;;DMHC^CHAR4 COUNCIL
	;;DMJC^CHAR4 COUNCIL
	;;DMKC^CHAR4 COUNCIL
	;;DMLC^CHAR4 COUNCIL
	;;DMPC^CHAR4 COUNCIL
	;;DMQC^CHAR4 COUNCIL
	;;DMRC^CHAR4 COUNCIL
	;;DMSC^CHAR4 COUNCIL
	;;DMTC^CHAR4 COUNCIL
	;;DMUC^CHAR4 COUNCIL
	;;DMVC^CHAR4 COUNCIL
	;;DMWC^CHAR4 COUNCIL
	;;FEEQ^CHAR4 COUNCIL
	;;FEEX^CHAR4 COUNCIL
	;;HDEC^CHAR4 COUNCIL
	;;HDHC^CHAR4 COUNCIL
	;;HDJC^CHAR4 COUNCIL
	;;HDKC^CHAR4 COUNCIL
	;;HDLC^CHAR4 COUNCIL
	;;HDMC^CHAR4 COUNCIL
	;;HDNC^CHAR4 COUNCIL
	;;HDPC^CHAR4 COUNCIL
	;;HDQC^CHAR4 COUNCIL
	;;HDRC^CHAR4 COUNCIL
	;;HTAC^CHAR4 COUNCIL
	;;HTBC^CHAR4 COUNCIL
	;;HTFC^CHAR4 COUNCIL
	;;HTSC^CHAR4 COUNCIL
	;;HTTC^CHAR4 COUNCIL
	;;HTUC^CHAR4 COUNCIL
	;;HTVC^CHAR4 COUNCIL
	;;HTWC^CHAR4 COUNCIL
	;;IACT^CHAR4 COUNCIL
	;;IDEC^CHAR4 COUNCIL
	;;IDFC^CHAR4 COUNCIL
	;;IDGC^CHAR4 COUNCIL
	;;IDHC^CHAR4 COUNCIL
	;;IDJC^CHAR4 COUNCIL
	;;IDKC^CHAR4 COUNCIL
	;;IDLC^CHAR4 COUNCIL
	;;IDMC^CHAR4 COUNCIL
	;;IDPC^CHAR4 COUNCIL
	;;IDQC^CHAR4 COUNCIL
	;;IDRC^CHAR4 COUNCIL
	;;IDUC^CHAR4 COUNCIL
	;;IDVC^CHAR4 COUNCIL
	;;IDWC^CHAR4 COUNCIL
	;;JCBC^CHAR4 COUNCIL
	;;LPNU^CHAR4 COUNCIL
	;;LVL1^CHAR4 COUNCIL
	;;LVL2^CHAR4 COUNCIL
	;;LVL3^CHAR4 COUNCIL
	;;LVL4^CHAR4 COUNCIL
	;;LVL5^CHAR4 COUNCIL
	;;MMMT^CHAR4 COUNCIL
	;;MMPS^CHAR4 COUNCIL
	;;MPAK^CHAR4 COUNCIL
	;;MPAL^CHAR4 COUNCIL
	;;MPAT^CHAR4 COUNCIL
	;;MPAX^CHAR4 COUNCIL
	;;MPAZ^CHAR4 COUNCIL
	;;NASG^CHAR4 COUNCIL
	;;NASK^CHAR4 COUNCIL
	;;NASM^CHAR4 COUNCIL
	;;NASN^CHAR4 COUNCIL
	;;NASO^CHAR4 COUNCIL
	;;NASP^CHAR4 COUNCIL
	;;NASQ^CHAR4 COUNCIL
	;;NASR^CHAR4 COUNCIL
	;;NAST^CHAR4 COUNCIL
	;;NASU^CHAR4 COUNCIL
	;;NASV^CHAR4 COUNCIL
	;;NASW^CHAR4 COUNCIL
	;;NASX^CHAR4 COUNCIL
	;;NASY^CHAR4 COUNCIL
	;;NASZ^CHAR4 COUNCIL
	;;NCBC^CHAR4 COUNCIL
	;;NDTR^CHAR4 COUNCIL
	;;NUDT^CHAR4 COUNCIL
	;;PDRC^CHAR4 COUNCIL
	;;PDSC^CHAR4 COUNCIL
	;;PDTC^CHAR4 COUNCIL
	;;PDVC^CHAR4 COUNCIL
	;;PLCH^CHAR4 COUNCIL
	;;PLMT^CHAR4 COUNCIL
	;;PLPS^CHAR4 COUNCIL
	;;PNFC^CHAR4 COUNCIL
	;;PNJC^CHAR4 COUNCIL
	;;PNPC^CHAR4 COUNCIL
	;;PNQC^CHAR4 COUNCIL
	;;PNRC^CHAR4 COUNCIL
	;;PNSC^CHAR4 COUNCIL
	;;PNTC^CHAR4 COUNCIL
	;;PNUC^CHAR4 COUNCIL
	;;PNWC^CHAR4 COUNCIL
	;;RDNU^CHAR4 COUNCIL
	;;RHAC^CHAR4 COUNCIL
	;;RHQC^CHAR4 COUNCIL
	;;RHUC^CHAR4 COUNCIL
	;;RHVC^CHAR4 COUNCIL
	;;RV20^CHAR4 COUNCIL
	;;RV45^CHAR4 COUNCIL
	;;RV60^CHAR4 COUNCIL
	;;SCHC^CHAR4 COUNCIL
	;;SCQC^CHAR4 COUNCIL
	;;SCTC^CHAR4 COUNCIL
	;;SCUC^CHAR4 COUNCIL
	;;SCVT^CHAR4 COUNCIL
	;;SNRC^CHAR4 COUNCIL
	;;SNVC^CHAR4 COUNCIL
	;;WCDC^CHAR4 COUNCIL
	;;WCEC^CHAR4 COUNCIL
	;;WCFC^CHAR4 COUNCIL
	;;WCGC^CHAR4 COUNCIL
	;;WCHC^CHAR4 COUNCIL
	;;WCJC^CHAR4 COUNCIL
	;;WCLC^CHAR4 COUNCIL
	;;WCMC^CHAR4 COUNCIL
	;;WCRC^CHAR4 COUNCIL
	;;WCSC^CHAR4 COUNCIL
	;;WCTC^CHAR4 COUNCIL
	;;WCUC^CHAR4 COUNCIL
	;;XYEL^CHAR4 COUNCIL
	;;QUIT
