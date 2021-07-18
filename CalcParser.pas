UNIT CalcParser;
  
INTERFACE
  TYPE
    NodePtr = ^Node;
    Node = RECORD
      left, right: NodePtr;
      txt: STRING; 
    END;
    TreePtr = NodePtr;
  VAR
    success : BOOLEAN;
    
  PROCEDURE InitParser(line : STRING);
  FUNCTION Parse : TreePtr;
  
IMPLEMENTATION
  USES CalcScan, Sysutils;
  
  PROCEDURE Expr(VAR e : TreePtr); FORWARD;
  PROCEDURE Term(VAR t : TreePtr); FORWARD;
  PROCEDURE Fact(VAR f : TreePtr); FORWARD;
  PROCEDURE S(VAR e : TreePtr); FORWARD;
  FUNCTION TreeOf(txt : STRING; left, right : TreePtr) : TreePtr; FORWARD;
  
  FUNCTION Parse : TreePtr;
    VAR e : TreePtr;
  BEGIN
    S(e);
    Parse := e;
  END;
  
  PROCEDURE InitParser(line : STRING);
  BEGIN
    Init(line);
    NewSym;
    success := TRUE;
  END;
  
  
  PROCEDURE S(VAR e : TreePtr);
  BEGIN
    (* S = Expr eof . *)
    Expr(e); IF NOT success THEN Exit;
    IF sym <> eofSym THEN BEGIN success := FALSE; Exit; END;
    NewSym;
  END;
  
  PROCEDURE Expr(VAR e : TreePtr);
    VAR t : TreePtr;
  BEGIN
    (* Expr = Term { '+' Term | '-' Term } . *)
    Term(e); IF NOT success THEN Exit;
    WHILE (sym = plusSym) OR (sym = minusSym) DO BEGIN
      CASE sym OF
        plusSym : BEGIN
          NewSym; (* skip plus *)
          Term(t); IF NOT success THEN Exit;
          (* SEM *) e := TreeOf('+', e, t); (* ENDSEM*)
        END;
        minusSym : BEGIN
          NewSym; (* skip minus *)
          Term(t); IF NOT success THEN Exit;
          (* SEM *) e := TreeOf('-', e, t); (* ENDSEM*)
        END;
      END;
    END;
  END;
  
  PROCEDURE Term(VAR t : TreePtr);
    VAR f : TreePtr;
  BEGIN
    (* Term = Fact { '*' Fact | '/' Fact } . *)
    Fact(t); IF NOT success THEN Exit;
    WHILE (sym = mulSym) OR (sym = divSym) DO BEGIN
      CASE sym OF
        mulSym: BEGIN
          NewSym; (* skip mul *)
          Fact(f); IF NOT success THEN Exit;
          (* SEM *) t := TreeOf('*', t, f); (* ENDSEM*)
        END;
        divSym: BEGIN
          NewSym; (* skip div *)
          Fact(f); IF NOT success THEN Exit;
          (* SEM *) t := TreeOf('/', t, f); (* ENDSEM*)
        END;
      END;
    END;
  END;
  
  PROCEDURE Fact(VAR f : TreePtr);
  BEGIN
    (* Fact = number | '(' Expr ')' . *)
    CASE sym OF
      numSym : BEGIN
        (* SEM *) f := TreeOf(IntToStr(value), NIL, NIL); (* ENDSEM *)
        NewSym;
      END;
      leftParSym : BEGIN
        NewSym; (* skip '(' *)
        Expr(f); IF NOT success THEN Exit;
        IF sym <> rightParSym THEN BEGIN success := FALSE; Exit; END;
        NewSym;
      END;
      ELSE BEGIN
        success := FALSE; Exit;
      END;
    END;
  END;
  
  FUNCTION TreeOf(txt : STRING; left, right : TreePtr) : TreePtr;
    VAR n : NodePtr;
  BEGIN
    New(n);
    n^.txt := txt;
    n^.left := left;
    n^.right := right;
    TreeOf := n;
  END;
  
BEGIN
END.
