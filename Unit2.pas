unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Memo2: TMemo;
    Label5: TLabel;
    Button3: TButton;
    Memo3: TMemo;
    Label6: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

type
  Symbols = record
     Symb : string[30];  // symbol (key value)
     Position : integer;  // Position
     end;

 // struktura za Symbols

 type
  SymbolsAttr = record
     Symb : string[30];
     Attr : integer;
  end;

  type
   TetR = record
     Command  : string;
     Op1      : integer;
     Op2      : integer;
     Result   : integer;
  end;

   var
   IndexTab : array[1 .. 200] of Symbols; // redovete na tablicata (Symbol)
   SymbolsMatrix : array[1 .. 200] of SymbolsAttr; // tablicata IndexTab
   PositionNumber : array [1 .. 200] of integer; // masiv s pozicii ot simvoli
   TetrArray : array [1 .. 200] of TetR; // masiv s tetradi
   S : string; // zapanza infoto ot Memo1
   Buff : string;

   // {Parsing & Semantic}

   Nxt  : integer;  {Next symbol}
   R    : integer;   // vremenen rezultat
   Res  : string;  // rezultat vryshtan ot funkciqta (parametar)
   N    : integer; // poreden nomer na vremennata promenliva result
   TetN : integer; // nomer na tetradata


   i : Integer = 0; // broqch
   j, p, y, z : Integer;
   h : Integer = 0;

   // mnojestvo ot propusnati simvoli
   // #9 - tabulaciq, #10 - nov red, #13 - carrige return (enter button)

   NL : set of char = [' ', #9, #10, #13];

   // mnojestvo ot identifikatori

   L : set of char = ['a'..'z','A'..'Z','_','а'..'я','А'..'Я'];

   // mnojestrvo ot celi 4islа

   D : set of char  = ['0'..'9'];

   // mnojestvo ot operandi

   O : set of char = ['+','-','*','/','=','^','%','>','<', ';', ':', '.', '(', ')'];

   //mnojestwo ot drobni 4isla

   F : set of char = ['0'..'9', ','];

function FindTab (Symb : string; Position : integer) : Integer;
  var Bot, Top, Mid : integer;
 begin
  {inicialization}
  Bot := 1 ;
  Top := h ;
  while Bot <= Top do
   begin
    {namirane na srednata stoinost na intervala na tyrsene}
    Mid := (Bot + Top) div 2 ;
    {sravneniq}
       if IndexTab[Mid].Symb > Symb then Top := Mid - 1
       else if IndexTab[Mid].Symb < Symb then Bot := Mid + 1
       else begin
       {nameren element}
       FindTab := IndexTab[Mid].Position;
       Exit;
   end;
 end;

  j := h;
  for j := h downto 1 do

  if IndexTab[j].Symb > Symb then IndexTab[j+1] := IndexTab[j]
  else break;

  h := h + 1 ;

  IndexTab[j+1].Symb := Symb ;
  IndexTab[j+1].Position :=  h;

  SymbolsMatrix[h].Symb := Symb ;
  SymbolsMatrix[h].Attr := Position ;

  FindTab := h;
end;

// proverqvame dali poredniq simvol e mnojestvoto na identifikatorite ili cirfite

procedure AlphaDigit;
begin
  Buff := '';
  while S[i] in L + D do
    begin
      Buff := Buff + S[i];
      inc(i);
    end;
  PositionNumber[p] := FindTab(Buff, 1);
  inc(p);
end;

// funkcia izvejdashta greshki

procedure Error(number : integer);
begin

  case number of
    1 : showmessage('Въведеното число има некоректен десетичен отделител (,,)!');
    2 : showmessage('Въведен е непозволен символ - "' + S[i] + '"!')
  end;

  raise Exception.Create('');
End;

// proverka v mnojestvo na operandite;

procedure Oh();
begin
   Buff := '';

   if S[i] in O then
   begin
        if (S[i]= '=') and (S[i+1] = '=')  then
        begin
          Buff := S[i] + S[i+1];
          inc(i);
          inc(i);
        end
        else if (S[i]= ':') and (S[i+1] = '=') then
        begin
          Buff := S[i] + S[i+1];
          inc(i);
          inc(i);
        end
        else
        begin
          Buff := Buff + S[i];
          inc(i);
        end;
   end;
  PositionNumber[p] := FindTab(Buff, 3);
  inc(p);
end;

procedure dgt;
var
br : integer;
begin
  Buff := '';
  br := 0;
  while S[i] in F do
  begin
    if S[i] = ',' then
    Begin
     br := br + 1;
     if br > 1 then
      Error(1)
    end;
    Buff := Buff + S[i];
    inc(i);
  end;
  PositionNumber[p] := FindTab(Buff, 2);
  inc(p);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 edit3.Text := inttostr(FindTab(Edit1.Text, strtoint( Edit2.Text)))
end;

procedure TForm2.Button2Click(Sender: TObject);

var
k  : integer; // counter

begin
 try
 S := memo1.Text;

 i := 1;

 while i <= Length(S) do
 begin

 // proverka za prazno mqsto, tabulaciq, nov red, (space)

 if S[i] in NL then inc(i)
 else if S[i] in L then
  Alphadigit()
 else if S[i] in D then
  dgt()
 else if S[i] in O then
  oh()
 else Error(2)
 end;

 except
 end;
   for k := 1 to p-1 do
   begin
   Memo2.Lines.Add(SymbolsMatrix[PositionNumber[k]].Symb);
   end;
end;

// sintaktichen analizator

procedure Compiler;      { Parser & Semantic }

 procedure Error(number : integer);
  begin
     case number of
        1 : showmessage('Липсва NAME');
        2 : showmessage('Липсва ID');
        3 : showmessage('Липсва ";"');
        4 : showmessage('Грешка при логическите символи за сравнение "<, >, ="');
        5 : showmessage('Липсва ":="');
        6 : showmessage('Липсва "HENCE"');
        7 : showmessage('Липсва "("');
        8 : showmessage('Липсва ")"');
        9 : showmessage('Липсва константа / променлива / отваряща скоба!');
        10: showmessage('Липсва "START"');
        11: showmessage('Липсва "STOP"');
        12: showmessage('Липсва аритметически израз (+ или -)!');
        13: showmessage('Очаква се идентификатор (променлива, цикъл)!');
        14: showmessage('Очаква се символ за край на програмата - "."!');
  end;

  raise Exception.Create('');
  end;

 function LexAn : integer; // vryshta koda na simvola
  begin
   { Lexical Analisys }
   inc(z);
   LexAn := SymbolsMatrix[PositionNumber[z]].Attr;
  end;

procedure head;
begin
   if Nxt <> 103 then Error(1); // NAME (103)
    Nxt := LexAn;
   if Nxt <> 1 then Error(2); // ID
    Nxt := LexAn;
   if Nxt <> 116 then Error(3); // ; (116)
    Nxt := LexAn;
end;

 function SysVar : integer;
  var v : string;
  begin
   v := '&'+IntToStr(N);
   SysVar := FindTab(v, 1);
   inc(N);
  end;

procedure NewTetr(Command:string; Op1, Op2, Result : integer);
begin
   TetrArray[TetN].Command      := Command;
   TetrArray[TetN].Op1          := Op1;
   TetrArray[TetN].Op2          := Op2;
   TetrArray[TetN].Result       := Result;
   inc(TetN);
end;

procedure expr (var Op1 : integer); forward;

procedure bool(var Op:integer);
   var Op1,Op2 : integer; znak : string;
begin
   expr(Op1);
   if not (Nxt in [115, 114, 113, 118])  then Error(4);
   znak := SymbolsMatrix[PositionNumber[z]].Symb;
   Nxt := LexAn;
   expr(Op2);
   Op := SysVar;
   NewTetr (znak, Op1, Op2, Op);
end;

procedure stat;
   var Op, Op3, BRZ, JMP, ID  : integer;
begin
   if Nxt = 1 then  // ID (126)
   begin
   ID := PositionNumber[z];
    Nxt := LexAn;
   if Nxt <> 113 then Error(5); // := (113)
   Nxt := LexAn;
   expr(Op3);
   NewTetr(':=', Op3, 0, ID);
   end else
   if Nxt = 104 then // WHEN (104) (if)
   begin
    Nxt := LexAn;
   bool(Op3);
   BRZ := TetN;
   NewTetr('BRZ', 0, Op3, 0);
   if Nxt <> 125 then Error(6); // HENCE (125) (then)
   Nxt := LexAn;
   stat;
   NewTetr('JMP', 0, 0, 0);
   if Nxt = 105 then // OTHERWISE (105) (else)
   begin
    JMP := TetN - 1;
    TetrArray[BRZ].Op1 := TetN;
    Nxt := LexAn;
    stat;
    TetrArray[JMP].Op1 := TetN;
   end;
{ vryshtame se da popylnim else-a }
   end else
   if Nxt = 106 then // TILL (106) (while)
   begin

   Nxt := LexAn;
   if Nxt <> 127 then Error(7);  // ( (127)
   Nxt := LexAn;
   if Nxt <> 1 then Error(2); // ID
   ID := PositionNumber[z];
    Nxt := LexAn;
   if Nxt <> 113 then Error(5); // := 113
   Nxt := LexAn;
   expr(Op3);
   NewTetr(':=', Op3, 0, ID);
   JMP := TetN;
   if Nxt <> 116 then Error(3); // ; (116)
   Nxt := LexAn;
   expr(Op3);
   Op := SysVar;
   NewTetr ('<', ID, Op3, Op);
   BRZ := TetN;
   NewTetr('BRZ', 0, Op, 0);
   if Nxt <> 116 then Error(3); // ; (116)
   Nxt := LexAn;
   expr(Op3);
   NewTetr ('+', ID, Op3, ID);
   if Nxt <> 128 then Error(8); // ) (128)
   Nxt := LexAn;
   stat;
   NewTetr('JMP', JMP, 0, 0);
   TetrArray[BRZ].Op1 := TetN;
   end
   else Error(13);
end;

procedure block;
begin
 stat;
 while Nxt = 116 do // ; (116)
 begin
  Nxt := LexAn;
 stat;
 end;
end;

procedure factor(var Op:integer);
begin
   if Nxt = 127 then  // ( 127
     begin
       Nxt := LexAn;
       expr(Op);
       if Nxt <> 128 then Error(8); // ) 128
       Nxt := LexAn;
     end else
   if Nxt = 1 then // ID
     begin
        Op := PositionNumber[z];
       Nxt := LexAn;
     end else
   if Nxt = 2 then // CONST
    begin
      Op := PositionNumber[z];
      Nxt := LexAn;
    end
   else Error(9);
end;

procedure term(var Op1:integer);
  var Op2 : integer;
  var znak : string;
begin
   factor(Op1);
   while Nxt in [110, 111] do
     begin
     znak := SymbolsMatrix[PositionNumber[z]].Symb;
      Nxt := LexAn;
      factor(Op2);
      R := SysVar;
      NewTetr(znak, Op1, Op2, R);
      Op1 := R;
     end;
end;

procedure expr(var Op1:integer);
  var Op2:integer; znak : string;
begin
   term(Op1);
   while Nxt in [108, 109] do
     begin
       znak := SymbolsMatrix[PositionNumber[z]].Symb;
       Nxt := LexAn;
       term(Op2);
       R := SysVar;
       NewTetr (znak, Op1, Op2, R);
       Op1 := R;
     end;
end;

procedure main;
   var Prom : integer;
begin
   head;
   if Nxt <> 101 then Error(10); // START 101
   Nxt := LexAn;
   block;
   if Nxt <> 102 then Error(11); // STOP 102
   Nxt := LexAn;
   if Nxt <> 129 then Error (14); // STOP.
   Nxt := LexAn;
end;

begin
    z := 0;
    N := 1;     // SysVar counter
    TetN := 1;     // Tetr counter
    Nxt := LexAn;
    main;
    NewTetr('STOP',0,0,0);
end;

procedure TForm2.Button3Click(Sender: TObject);
begin

    h := 0; // nulirane na FindTab;
    p := 1; // nulirane na PositionNumber;
    y := 0;

    for y := 1 to 200 do
    begin
      PositionNumber[y] := 0;
    end;
   // specialni dumi (operatori)

   FindTab('START', 101); // BEGIN;
   FindTab('STOP', 102); // END;
   FindTab('NAME', 103); // Program ID;

   // za cikyl

   FindTab('WHEN', 104); // IF;
   FindTab('OTHERWISE', 105); // ELSE;
   FindTab('TILL', 106); // WHILE;

  // za prisvoqvane/aritmetika

   FindTab('+', 108); // +
   FindTab('-', 109); // -
   FindTab('*', 110); // *
   FindTab('/', 111); // /
   FindTab(':=', 113); // prisvoqvane
   FindTab('<', 114); // po-malko
   FindTab('>', 115); // po-golqmo
   FindTab(';', 116); // krai na logicheski red
   FindTab('=', 118); // sravnenie
   FindTab('AND', 119); // logichesko "AND" (i)
   FindTab('OR', 120); // logichesko "OR" (ili)
   FindTab('PRINT', 121);// izvejdane
   FindTab('READ', 122); // chetene
   FindTab('HENCE', 125); // then
   FindTab('(', 127);
   FindTab(')', 128);
   FindTab('.',129);
   FindTab(':', 130);

   Button2.Click; // leksichen analizator

   Compiler;  // sintaktichen analizator
   showmessage('Кода е компилиран успешно!');

end;

procedure TForm2.Button4Click(Sender: TObject);
   var
    counter : integer;
begin
for counter := 1 to TetN do
   begin

   // aritmetichni operacii

   if  TetrArray[counter].Command = '*' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('MUL   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
   if  TetrArray[counter].Command = '/' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('DIV   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
    if  TetrArray[counter].Command = '+' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('ADD   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
    if  TetrArray[counter].Command = '-' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('SUB   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;

   // sravnitelni operacii

   if  TetrArray[counter].Command = '=' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('SUB   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('BRZ   ' + 'cmp1');
        Memo3.Lines.Add('LDA   ' + '#0');
        Memo3.Lines.Add('JMP   ' + 'cmp2');
        Memo3.Lines.Add('cmp1  ' + 'LDA   ' + '#1');
        Memo3.Lines.Add('cmp2  ' + 'STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
   if  TetrArray[counter].Command = '>' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('SUB   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('BRZ   ' + 'cmp1');
        Memo3.Lines.Add('LDA   ' + '#0');
        Memo3.Lines.Add('JMP   ' + 'cmp2');
        Memo3.Lines.Add('cmp1  ' + 'LDA   ' + '#1');
        Memo3.Lines.Add('cmp2  ' + 'STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
   if  TetrArray[counter].Command = '<' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('SUB   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('BRZ   ' + 'cmp1');
        Memo3.Lines.Add('LDA   ' + '#1');
        Memo3.Lines.Add('JMP   ' + 'cmp2');
        Memo3.Lines.Add('cmp1  ' + 'LDA   ' + '#0');
        Memo3.Lines.Add('cmp2  ' + 'STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
   if  TetrArray[counter].Command = ':=' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
        Memo3.Lines.Add('STA   ' + SymbolsMatrix[TetrArray[counter].Result].Symb);
      end;
   if  TetrArray[counter].Command = 'BRZ' then
      begin
        Memo3.Lines.Add('LDA   ' + SymbolsMatrix[TetrArray[counter].Op2].Symb);
        Memo3.Lines.Add('BRZ   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
      end
    else if TetrArray[counter].Command = 'JMP' then
      begin
        Memo3.Lines.Add('JMP   ' + SymbolsMatrix[TetrArray[counter].Op1].Symb);
      end;
   if  TetrArray[counter].Command = 'STOP' then
      begin
        Memo3.Lines.Add('BRK');
      end;
   end;
end;

procedure TForm2.FormCreate(Sender: TObject);
  begin
    p := 1;
  end;
end.
