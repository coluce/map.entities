unit source.builder;

interface

uses
  system.classes,
  source,
  provider;

type

  TSourceBuilder = class(TInterfacedObject, ISourceBuilder)
  private
    FTable: ITable;
    FMetadata: TSourceMetadata;
    function DatabaseTypeToPascalType(const AField: IField): string;
    function DatabaseTypeToProviderParamType(const AField: IField): string;
    function DatabaseTypeToDataSetParamType(const AField: IField): string;
  public
    constructor Create(const ATable: ITable; AMetadata: TSourceMetadata);

    function MainClass: string;
    function EntityClass: string;
    function DAOClass: string;
  end;

implementation

uses
  system.generics.collections,
  System.Generics.Defaults,
  system.strutils,
  system.sysutils;

{ TSourceBuilder }

constructor TSourceBuilder.Create(const ATable: ITable; AMetadata: TSourceMetadata);
begin
  FTable := ATable;
  FMetadata := AMetadata;
end;

function TSourceBuilder.DAOClass: string;
var
  vSource: TStrings;
  vList: TList<IField>;
  vField: IField;
  vPos: integer;
  vCountPrimaryKeyFields: integer;
begin

  vList := TList<IField>.Create;
  try

    vList.AddRange(FTable.Fields.Values);

    vList.Sort(TComparer<IField>.Construct(
      function (const L, R: IField): integer
      begin
        if L.ID = R.ID then
        begin
          Result := 0;
        end
        else
        begin
          if L.ID < R.ID then
          begin
            Result := -1;
          end
          else
          begin
            Result := 1;
          end;
        end;
      end
    ));

    vCountPrimaryKeyFields := 0;
    for vField in vList do
    begin
      if vField.PrimaryKey then
      begin
        inc(vCountPrimaryKeyFields);
      end;
    end;

    vSource := TStringList.Create;
    try
      vSource.Add('unit ' + FMetadata.DaoUnitName +';');
      vSource.Add('');
      vSource.Add('interface');
      vSource.Add('');
      vSource.Add('uses');
      vSource.Add('  Data.DB,');
      vSource.Add('  ' + FMetadata.MainUnitName + ';');
      vSource.Add('');
      vSource.Add('type');
      vSource.Add('');
      vSource.Add('  ' + FMetadata.DaoClassName + ' = class(TInterfacedObject, ' + FMetadata.DaoInterfaceName + ')');
      vSource.Add('  private');
      vSource.Add('    { private declarations }');
      vSource.Add('    function CreateEntityFromDataSet(const ADataSet: TDataSet): ' + FMetadata.EntityInterfaceName + ';');
      vSource.Add('  public');
      vSource.Add('    { public declarations }');
      vSource.Add('    procedure Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
      vSource.Add('    procedure Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
      vSource.Add('    function Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
      vSource.Add('  end;');
      vSource.Add('');
      vSource.Add('implementation');
      vSource.Add('');
      vSource.Add('uses');
      vSource.Add('  provider;');
      vSource.Add('');
      vSource.Add(' { ' + FMetadata.DaoClassName + ' }');
      vSource.Add('');
      vSource.Add('function ' + FMetadata.DaoClassName + '.CreateEntityFromDataSet(const ADataSet: TDataSet): ' + FMetadata.EntityInterfaceName + ';');
      vSource.Add('begin');
      vSource.Add('  Result := ' + FMetadata.MainClassName + '.Entity;');

      for vField in vList do
      begin
        vSource.Add('  Result.' + vField.Name + '(ADataSet.FieldByname(' + QuotedStr(vField.Name) + ').' + DatabaseTypeToDataSetParamType(vField) + ');');
      end;

      vSource.Add('end;');
      vSource.Add('');
      vSource.Add('procedure ' + FMetadata.DaoClassName + '.Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
      vSource.Add('var');
      vSource.Add('  vQry: TStrings;');
      vSource.Add('begin');
      vSource.Add('');
      vSource.Add('  vQry := TStringList.Create;');
      vSource.Add('  try');
      vSource.Add('');
      vSource.Add('    vQry.Add(''update or insert into ' + FTable.Name + ' ('');');

      vPos := 0;
      for vField in vList do
      begin
        inc(vPos);
        vSource.Add('    vQry.Add(''  ' + vField.Name + IfThen(vPos < vList.Count, ',', EmptyStr) + ''');');
      end;
      vSource.Add('    vQry.Add('')values('');');

      vPos := 0;
      for vField in vList do
      begin
        inc(vPos);
        vSource.Add('    vQry.Add(''  :' + vField.Name + IfThen(vPos < vList.Count, ',', EmptyStr) +''');');
      end;

      vSource.Add('    vQry.Add('') matching ('');');

      vPos := 0;
      for vField in vList do
      begin
        if vField.PrimaryKey then
        begin
          inc(vPos);
          vSource.Add('    vSQL.Add('' ' + vField.Name + IfThen(vPos < vCountPrimaryKeyFields, ',', EmptyStr) + ''');');
        end;
      end;
      vSource.Add('    vQry.Add('');'');');
      vSource.Add('');
      vSource.Add('    TProvider.Firebird');
      vSource.Add('      .SetSQL(vQry)');
      for vField in vList do
      begin
        vSource.Add('      .' + DatabaseTypeToProviderParamType(vField) + '('+ QuotedStr(vField.Name) +', Value.' + vField.Name + ')');
      end;
      vSource.Add('      .Execute;');
      vSource.Add('');
      vSource.Add('  finally');
      vSource.Add('    vQry.Free;');
      vSource.Add('  end;');
      vSource.Add('');
      vSource.Add('end;');
      vSource.Add('');
      vSource.Add('procedure ' + FMetadata.DaoClassName + '.Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
      vSource.Add('var');
      vSource.Add('  vSQL: TStrings;');
      vSource.Add('begin');
      vSource.Add('');
      vSource.Add('  vSQL := TStringList.Create;');
      vSource.Add('  try');
      vSource.Add('');
      vSource.Add('    vSQL.Add(''delete'');');
      vSource.Add('    vSQL.Add(''from ' + FTable.Name + ' '');');
      vSource.Add('    vSQL.Add(''where'');');
      vPos := 0;
      for vField in vList do
      begin
        if vField.PrimaryKey then
        begin
          inc(vPos);
          vSource.Add('    vSQL.Add('' ' + vField.Name + ' = :' + vField.Name +' ' + IfThen(vPos < vCountPrimaryKeyFields, 'and', EmptyStr) + ' '');');
        end;
      end;

      vSource.Add('');
      vSource.Add('    TProvider.Firebird');
      vSource.Add('      .SetSQL(vSQL)');

      for vField in vList do
      begin
        if vField.PrimaryKey then
        begin
          vSource.Add('      .' + DatabaseTypeToProviderParamType(vField) + '('+ QuotedStr(vField.Name) +', Value.' + vField.Name + ')');
        end;
      end;

      vSource.Add('      .Execute;');
      vSource.Add('');
      vSource.Add('  finally');
      vSource.Add('    vSQL.Free;');
      vSource.Add('  end;');
      vSource.Add('');
      vSource.Add('end;');
      vSource.Add('');
      vSource.Add('function ' + FMetadata.DaoClassName + '.Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
      vSource.Add('var');
      vSource.Add('  vDataSet: TFDMemTable;');
      vSource.Add('  vEntity: ' + FMetadata.EntityInterfaceName + ';');
      vSource.Add('  vSQL: TStrings;');
      vSource.Add('begin');
      vSource.Add('');
      vSource.Add('  SetLength(Result, 0);');
      vSource.Add('');
      vSource.Add('  vDataSet := TFDMemTable.Create(nil);');
      vSource.Add('  try');
      vSource.Add('    vSQL := TStringList.Create;');
      vSource.Add('    try');
      vSource.Add('      vSQL.Add(''select * '');');
      vSource.Add('      vSQL.Add(''from ' + FTable.Name + ' '');');
      vSource.Add('      vSQL.Add(''where'');');

      vPos := 0;
      for vField in vList do
      begin
        if vField.PrimaryKey then
        begin
          inc(vPos);
          vSource.Add('      vSQL.Add(''  ' + vField.Name + ' = :' + vField.Name +' ' + IfThen(vPos < vCountPrimaryKeyFields, 'and', EmptyStr) + ' '');');
        end;
      end;

      vSource.Add('');
      vSource.Add('      TProvider.Firebird');
      vSource.Add('        .SetSQL(vSQL)');
      vSource.Add('        .SetDataset(vDataSet)');
      for vField in vList do
      begin
        if vField.PrimaryKey then
        begin
          vSource.Add('        .' + DatabaseTypeToProviderParamType(vField) + '('+ QuotedStr(vField.Name) +', Value.ParamByName(' + QuotedStr(vField.Name) + '))');
        end;
      end;
      vSource.Add('        .Open;');
      vSource.Add('');
      vSource.Add('      vDataSet.First;');
      vSource.Add('      while not vDataSet.EOF do');
      vSource.Add('      begin');
      vSource.Add('');
      vSource.Add('        vEntity := CreateEntityFromDataSet(vDataSet);');
      vSource.Add('');
      vSource.Add('        SetLength(Result, Length(Result) + 1);');
      vSource.Add('        Result[Length(Result) - 1] := vEntity;');
      vSource.Add('');
      vSource.Add('        vDataSet.Next;');
      vSource.Add('');
      vSource.Add('      end;');
      vSource.Add('');
      vSource.Add('    finally');
      vSource.Add('      vDataSet.Free;');
      vSource.Add('    end;');
      vSource.Add('');
      vSource.Add('  finally');
      vSource.Add('    vDataSet.Free;');
      vSource.Add('  end;');
      vSource.Add('');
      vSource.Add('end;');
      vSource.Add('');
      vSource.Add('end.');

      Result := vSource.Text;

    finally
      vSource.Free;
    end;
  finally
    vList.Free;
  end;
end;

function TSourceBuilder.EntityClass: string;
var
  vSource: TStrings;
  vField: IField;
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + FMetadata.EntityUnitName +';');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('  ' + FMetadata.MainUnitName + ';');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.EntityClassName + ' = class(TInterfacedObject, ' + FMetadata.EntityInterfaceName + ')');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    F' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    procedure Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('    function Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    property ' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ' read Get' + vField.Name + ' write Set' + vField.Name + ';');
    end;
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.EntityClassName + ' }');
    vSource.Add('');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('procedure ' + FMetadata.EntityClassName + '.Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('begin');
      vSource.Add('  F' + vField.Name + ' := Value;');
      vSource.Add('end;');
      vSource.Add('');
      vSource.Add('function ' + FMetadata.EntityClassName + '.Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
      vSource.Add('begin');
      vSource.Add('  Result := F' + vField.Name + ';');
      vSource.Add('end;');
    end;

    vSource.Add('');
    vSource.Add('end.');

    Result := vSource.Text;

  finally
    vSource.Free;
  end;
end;

function TSourceBuilder.MainClass: string;
var
  vSource: TStrings;
  vField: IField;
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + FMetadata.MainUnitName +';');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.EntityInterfaceName + ' = interface');
    vSource.Add('    [' + QuotedStr(TGuid.NewGuid.ToString) + ']');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    F' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    procedure Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('    function Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    property ' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ' read Get' + vField.Name + ' write Set' + vField.Name + ';');
    end;
    vSource.Add('  end;');
    vSource.Add('');

    vSource.Add('  ' + FMetadata.DaoInterfaceName + ' = interface');
    vSource.Add('    [' + QuotedStr(TGuid.NewGuid.ToString) + ']');
    vSource.Add('    procedure Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    procedure Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    function Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.MainClassName + ' = class');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');
    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    vSource.Add('    class function Entity: ' + FMetadata.EntityInterfaceName + ';');
    vSource.Add('    class function Dao: ' + FMetadata.DaoInterfaceName + ';');
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('  ' + FMetadata.EntityUnitName + ',');
    vSource.Add('  ' + FMetadata.DaoUnitName + ';');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.MainClassName + ' }');
    vSource.Add('');
    vSource.Add('class function Entity: ' + FMetadata.EntityInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := ' + FMetadata.EntityClassName + '.Create;');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('class function Dao: ' + FMetadata.DaoInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := ' + FMetadata.DaoClassName + '.Create;');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('end.');

    Result := vSource.Text;

  finally
    vSource.Free;
  end;
end;

function TSourceBuilder.DatabaseTypeToProviderParamType(const AField: IField): string;
begin
  Result := 'SetStringParam';

  if UpperCase(AField.FieldType).Equals('CHAR') then
    Result := 'SetStringParam';

  if UpperCase(AField.FieldType).Equals('VARCHAR') then
    Result := 'SetStringParam';

  if UpperCase(AField.FieldType).Equals('INTEGER') then
    Result := 'SetIntegerParam';

  if UpperCase(AField.FieldType).Equals('SMALLINT') then
    Result := 'SetIntegerParam';

  if UpperCase(AField.FieldType).Equals('TIMESTAMP') then
    Result := 'SetDateTimeParam';

  if UpperCase(AField.FieldType).Equals('DATE') then
    Result := 'SetDateParam';

  if UpperCase(AField.FieldType).Equals('TIME') then
    Result := 'SetTimeParam';

  if UpperCase(AField.FieldType).Equals('NUMERIC') then
    Result := 'SetFloatParam';

  if UpperCase(AField.FieldType).Equals('DECIMAL') then
    Result := 'SetFloatParam';

  if UpperCase(AField.FieldType).Equals('DOUBLE PRECISION') then
    Result := 'SetFloatParam';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 0') then
    Result := 'SetMemoryStreamParam';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 1') then
    Result := 'SetStringParam';
end;

function TSourceBuilder.DatabaseTypeToDataSetParamType(const AField: IField): string;
begin
  Result := 'AsString';

  if UpperCase(AField.FieldType).Equals('CHAR') then
    Result := 'AsString';

  if UpperCase(AField.FieldType).Equals('VARCHAR') then
    Result := 'AsString';

  if UpperCase(AField.FieldType).Equals('INTEGER') then
    Result := 'AsInteger';

  if UpperCase(AField.FieldType).Equals('SMALLINT') then
    Result := 'AsInteger';

  if UpperCase(AField.FieldType).Equals('TIMESTAMP') then
    Result := 'AsDateTime';

  if UpperCase(AField.FieldType).Equals('DATE') then
    Result := 'AsDateTime';

  if UpperCase(AField.FieldType).Equals('TIME') then
    Result := 'AsDateTime';

  if UpperCase(AField.FieldType).Equals('NUMERIC') then
    Result := 'double';

  if UpperCase(AField.FieldType).Equals('DECIMAL') then
    Result := 'AsFloat';

  if UpperCase(AField.FieldType).Equals('DOUBLE PRECISION') then
    Result := 'AsFloat';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 0') then
    Result := 'AsBlob';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 1') then
    Result := 'AsString';
end;

function TSourceBuilder.DatabaseTypeToPascalType(const AField: IField): string;
begin
  Result := AField.FieldType;

  if UpperCase(AField.FieldType).Equals('CHAR') then
    Result := 'string';

  if UpperCase(AField.FieldType).Equals('VARCHAR') then
    Result := 'string';

  if UpperCase(AField.FieldType).Equals('INTEGER') then
    Result := 'integer';

  if UpperCase(AField.FieldType).Equals('SMALLINT') then
    Result := 'integer';

  if UpperCase(AField.FieldType).Equals('TIMESTAMP') then
    Result := 'TDateTime';

  if UpperCase(AField.FieldType).Equals('DATE') then
    Result := 'TDate';

  if UpperCase(AField.FieldType).Equals('TIME') then
    Result := 'TTime';

  if UpperCase(AField.FieldType).Equals('NUMERIC') then
    Result := 'double';

  if UpperCase(AField.FieldType).Equals('DECIMAL') then
    Result := 'double';

  if UpperCase(AField.FieldType).Equals('DOUBLE PRECISION') then
    Result := 'double';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 0') then
    Result := 'TMemoryStream';

  if UpperCase(AField.FieldType).Equals('BLOB SUB_TYPE 1') then
    Result := 'string';

end;

end.
