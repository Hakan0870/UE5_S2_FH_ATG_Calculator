UNIT CalcScan;
  
INTERFACE
  TYPE
    Symbol = 
        (
            eofSym,
            numSym,
            plusSym,
            minusSym,
            mulSym,
            divSym, 
            leftParSym, 
            rightParSym, 
            noSym
        );
  VAR
    sym : Symbol;
    value : INTEGER;

  PROCEDURE Init(line : STRING); 
  PROCEDURE NewSym; 

IMPLEMENTATION
  CONST
    EofCh = Chr(0);
    TabCh = Chr(9);

  VAR
    srcLine : STRING;
    ch : CHAR;
    colNr : INTEGER;

  PROCEDURE NewCh; FORWARD;

  PROCEDURE Init(line : STRING);
  BEGIN
    srcLine := line;
    colNr := 0;
    NewCh;
  END;

  PROCEDURE NewSym; 
  BEGIN
    WHILE(ch = ' ') OR (ch = TabCh) DO
      NewCh; 
    CASE ch OF
      '+' : BEGIN sym := plusSym; NewCh; END;
      '-' : BEGIN sym := minusSym; NewCh; END;
      '/' : BEGIN sym := divSym; NewCh; END;
      '*' : BEGIN sym := mulSym; NewCh; END;
      '(' : BEGIN sym := leftParSym; NewCh; END;
      ')' : BEGIN sym := rightParSym; NewCh; END;
      eofCh: BEGIN sym := eofSym; NewCh; END;
      '0' .. '9' : BEGIN
        value := 0;
        WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
          value := value * 10 + Ord(ch) - Ord('0');
          newCh;
        END;
        Dec(colNr);
        sym := numSym;
        newCh;
      END;
      ELSE
        sym := noSym;
    END;
  END;

  PROCEDURE NewCh;
  BEGIN
    Inc(colNr);
    IF colNr <= Length(srcLine) THEN
      ch := srcLine[colNr]
    ELSE
      ch := EofCh;
  END;


BEGIN
END.