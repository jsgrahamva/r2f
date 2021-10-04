test15	;
RXC(IEN,OIEN,DATA,FS,CS,ERR)    ; process RXC (IV orders: additives/solutions) segment...
        I +$G(IEN)'>0!(+$G(OIEN)'>0)!($G(DATA)="")!($G(FS)="")!($G(CS)="") D ERRBLD^ALPBUTL1("RXC","",.ERR) Q
        N ALPBFILE,ALPBFNOD,ALPBGNOD,ALPBNAM,ALPBNEXT,ALPBNUM,ALPBTYP,ALPBUNIT
        S ALPBTYP=$P(DATA,FS,2)
        S ALPBGNOD=$S(ALPBTYP="A":8,ALPBTYP="B":9,1:0)
        I ALPBGNOD=0 D ERRBLD^ALPBUTL1("RXC","Unable to determine Additive or Solution in RXC segment",.ERR) Q
        S ALPBFNOD="53.7021"_$S(ALPBGNOD=8:3,1:4),ALPBFNOD="THE END"
        S ALPBNUM=$P($P(DATA,FS,3),CS,4)
        ; is this additive or solution already on file?...
        I $D(^ALPB(53.7,IEN,2,OIEN,ALPBGNOD,"B",ALPBNUM)) S ERR("DIERR")=0 Q
        ; if not, file it...
        S ALPBNAM=$P($P(DATA,FS,3),CS,5)
        S ALPBUNIT=$P(DATA,FS,4)_$P($P(DATA,FS,5),CS,5)
        S ALPBNEXT=+$O(^ALPB(53.7,IEN,2,OIEN,ALPBGNOD," "),-1)+1
        S ALPBFILE(ALPBFNOD,"+"_ALPBNEXT_","_OIEN_","_IEN_",",.01)=ALPBNUM
        S ALPBFILE(ALPBFNOD,"+"_ALPBNEXT_","_OIEN_","_IEN_",",1)=ALPBNAM
        S ALPBFILE(ALPBFNOD,"+"_ALPBNEXT_","_OIEN_","_IEN_",",2)=ALPBUNIT
        D UPDATE^DIE("","ALPBFILE","ALPBNEXT","ERR")
        Q
