PROGRAM CalcTest;
USES CalcParser, Sysutils;

  PROCEDURE PrintTreeGraphic(t: TreePtr);
      PROCEDURE WTG(t: TreePtr; level: INTEGER);
      BEGIN
        IF t <> NIL THEN BEGIN
          WTG(t^.right, level + 1);
          WriteLn(' ': level * 4, t^.txt:2, '<');
          WTG(t^.left, level + 1)
        END;
      END;
    BEGIN
      WTG(t, 0);
  END;
  
  PROCEDURE PreOrder(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      Write(t^.txt + ' ');
      PreOrder(t^.left);
      PreOrder(t^.right);
    END;
  END;
  
  PROCEDURE InOrder(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      InOrder(t^.left);
      Write(t^.txt + ' ');
      InOrder(t^.right);
    END;
  END;
  
  PROCEDURE PostOrder(t:TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      PostOrder(t^.left);
      PostOrder(t^.right);
      Write(t^.txt + ' ');
    END;
  END;
  
  FUNCTION ValueOf(t: TreePtr): INTEGER;
  BEGIN
    CASE t^.txt[1] OF
      '+' : ValueOf := ValueOf(t^.left) + ValueOf(t^.right);
      '-' : ValueOf := ValueOf(t^.left) - ValueOf(t^.right);
      '*' : ValueOf := ValueOf(t^.left) * ValueOf(t^.right);
      '/' : ValueOf := ValueOf(t^.left) DIV ValueOf(t^.right);
      ELSE ValueOf := StrToInt(t^.txt);
    END;
  END;
  
  VAR
    t: TreePtr;
BEGIN
InitParser('( 1 + 2) * 5 '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;

InitParser(' 1 + (2 * 5) '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;

InitParser(' 1 + 2 * 5 '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;    

InitParser(' 0 + 22 * 12 '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;

InitParser(' 0 + (0 * 5) '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;

InitParser(' 0 + 0 * 0 '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;


InitParser(' 1 + 2 * 3 + 1 '); t := Parse;
PrintTreeGraphic(t);
Write('In Order: ');
InOrder(t); WriteLn;
Write('Pre Order: ');
PreOrder(t); WriteLn;
Write('Post Order: ');
PostOrder(t); WriteLn;
WriteLn('Result: ', ValueOf(t));
WriteLn;

END.
