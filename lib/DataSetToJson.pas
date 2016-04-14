unit DataSetToJson;


interface

uses DB, XSuperObject, SQLMemMain, Variants;


function convertDataSetToJSON(Data: TDataSet; Filter: String = ''): String; overload;
function convertDataSetToJSON(Data: TSQLMemDataSet; Filter: String = ''): String; overload;

implementation


function convertDataSetToJSON(Data: TDataSet; Filter: String = ''): String;
var
  vJson : ISuperArray;
  vRecord : ISuperObject;
  fieldName: String;
  f: integer;
begin
  result := '';
  if Data=nil then
    exit;

  if (Filter <> '') then
  begin
    Data.Filtered := True;
    Data.Filter := Filter;
  end;

  Data.First;
  if Data.Eof then
  exit;

  vJson := TSuperArray.Create();


  try
    // get col names and types
    repeat
      vRecord := SO;
      for f := 0 to Data.FieldCount-1 do begin
        fieldName := Data.Fields[f].FieldName;
        with Data.Fields[f] do
        if IsNull then
          //Make field = null
          vRecord.O[fieldName] := nil
          else
        case DataType of
        ftBoolean: vRecord.B[fieldName] :=  AsBoolean;
        ftSmallint, ftInteger, ftWord, ftAutoInc: vRecord.I[fieldName] := AsInteger;
        ftLargeint: vRecord.D[fieldName] := AsLargeInt ;
        ftFloat, ftCurrency, ftBCD: vRecord.F[fieldName] := AsCurrency ;
        ftTimeStamp, ftDate, ftTime, ftDateTime: begin
          vRecord.D[fieldName] := AsDateTime;
        end;
        ftString, ftFixedChar, ftMemo: begin
            vRecord.S[fieldName] := {$ifdef UNICODE}AsAnsiString{$else}AsString{$endif};

        end;
        ftWideString: begin
          //pointer(TWideStringField(Data.Fields[f]).Value);
          vRecord.S[fieldName] :=  TWideStringField(Data.Fields[f]).Value;

        end;
        ftVariant: vRecord.V[fieldName] := AsVariant;
        ftBytes, ftVarBytes, ftBlob, ftGraphic, ftOraBlob, ftOraClob: begin
          vRecord.S[fieldName] :=  (Data.Fields[f] as TBlobField).AsString;
        end;
        {$ifdef ISDELPHI2007ANDUP}
        ftShortint, ftByte: vRecord.I[fieldName] := AsInteger ;
        ftLongWord: vRecord.I[fieldName] := AsLongWord;
        ftExtended, ftSingle: vRecord.I[fieldName] := AsFloat;
        ftWideMemo, ftFixedWideChar: begin

          vRecord.S[fieldName] := pointer(AsWideString);

        end;
        {$endif}
        else
           vRecord.O[fieldName] := nil  ; // unhandled field type
        end;

      end;

      vJson.Add (vRecord);

      Data.Next;
    until Data.Eof;

    result := vJson.AsJSON();
  finally
    vJson := nil;
  end;
end;

function convertDataSetToJSON(Data: TSQLMemDataSet; Filter: String = ''): String;
var
  vJson : ISuperArray;
  vRecord : ISuperObject;
  fieldName: String;
  f: integer;
begin
  result := '';
  if Data=nil then
    exit;

  if (Filter <> '') then
  begin
    Data.Filtered := True;
    Data.Filter := Filter;
  end;

  Data.First;
  if Data.Eof then
  exit;

  vJson := TSuperArray.Create();


  try
    // get col names and types
    repeat
      vRecord := SO;
      for f := 0 to Data.FieldCount-1 do begin
        fieldName := Data.Fields[f].FieldName;
        with Data.Fields[f] do
        if IsNull then
          //Make field = null
          vRecord.V[fieldName] :=  Null
          else
        case DataType of
        ftBoolean: vRecord.B[fieldName] :=  AsBoolean;
        ftSmallint, ftInteger, ftWord, ftAutoInc: vRecord.I[fieldName] := AsInteger;
        ftLargeint: vRecord.D[fieldName] := AsLargeInt ;
        ftFloat, ftCurrency, ftBCD: vRecord.F[fieldName] := AsCurrency ;
        ftTimeStamp, ftDate, ftTime, ftDateTime: begin
          vRecord.D[fieldName] := AsDateTime;
        end;
        ftString, ftFixedChar, ftMemo: begin
            vRecord.S[fieldName] := {$ifdef UNICODE}AsAnsiString{$else}AsString{$endif};

        end;
        ftWideString: begin
          //pointer(TWideStringField(Data.Fields[f]).Value);
          vRecord.S[fieldName] :=  TWideStringField(Data.Fields[f]).Value;

        end;
        ftVariant: vRecord.V[fieldName] := AsVariant;
        ftBytes, ftVarBytes, ftBlob, ftGraphic, ftOraBlob, ftOraClob: begin
          vRecord.S[fieldName] :=  (Data.Fields[f] as TBlobField).AsString;
        end;
        {$ifdef ISDELPHI2007ANDUP}
        ftShortint, ftByte: vRecord.I[fieldName] := AsInteger ;
        ftLongWord: vRecord.I[fieldName] := AsLongWord;
        ftExtended, ftSingle: vRecord.I[fieldName] := AsFloat;
        ftWideMemo, ftFixedWideChar: begin

          vRecord.S[fieldName] := pointer(AsWideString);

        end;
        {$endif}
        else
           vRecord.O[fieldName] := nil  ; // unhandled field type
        end;

      end;

      vJson.Add (vRecord);

      Data.Next;
    until Data.Eof;

    result := vJson.AsJSON();
  finally
    vJson := nil;
  end;
end;
end.
