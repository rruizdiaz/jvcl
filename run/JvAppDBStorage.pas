{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvAppDBStorage.pas, released on 2004-02-04.

The Initial Developer of the Original Code is Peter Th�rnqvist
Portions created by Peter Th�rnqvist are Copyright (C) 2004 Peter Th�rnqvist
All Rights Reserved.

Contributor(s):

Last Modified: 2004-02-04

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvAppDBStorage;

interface
uses
  SysUtils, Classes, DB,
  {$IFDEF COMPILER6_UP}
  Variants,
  {$ENDIF COMPILER6_UP}
  {$IFDEF VCL}
  DBCtrls,
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  QDBCtrls,
  {$ENDIF VisualCLX}
  JvAppStorage;

// DB table must contain 3 fields for the storage
// performance is probably improved if there is an index on the section and key fields (this can be unique)
// "section":string   - must support locate!
// "key":string      - must support locate!
// "value":string or memo

type
  TJvDBStorageWriteEvent = procedure(Sender: TObject; const Section, Key, Value: string) of object;
  TJvDBStorageReadEvent = procedure(Sender: TObject; const Section, Key: string; var Value: string) of object;
  EJvAppDBStorageError = class(Exception);

  TJvCustomAppDBStorage = class(TJvCustomAppStorage)
  private
    FSectionLink: TFieldDataLink;
    FKeyLink: TFieldDataLink;
    FValueLink: TFieldDataLink;
    FOnRead: TJvDBStorageReadEvent;
    FOnWrite: TJvDBStorageWriteEvent;
    FBookmark:TBookmarkStr;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
    function GetKeyField: string;
    function GetSectionField: string;
    function GetValueField: string;
    procedure SetKeyField(const Value: string);
    procedure SetSectionField(const Value: string);
    procedure SetValueField(const Value: string);
  protected
    function FieldsAssigned: boolean;
    procedure EnumFolders(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
    procedure EnumValues(const Path: string; const Strings: TStrings;
      const ReportListAsValue: Boolean = True); override;
    function PathExistsInt(const Path: string): boolean; override;
    function IsFolderInt(Path: string; ListIsValue: Boolean = True): Boolean; override;
    procedure RemoveValue(const Section, Key: string);
    procedure DeleteSubTreeInt(const Path: string); override;

    function ValueStoredInt(const Path: string): Boolean; override;
    procedure DeleteValueInt(const Path: string); override;
    function DoReadInteger(const Path: string; Default: Integer): Integer; override;
    procedure DoWriteInteger(const Path: string; Value: Integer); override;
    function DoReadFloat(const Path: string; Default: Extended): Extended; override;
    procedure DoWriteFloat(const Path: string; Value: Extended); override;
    function DoReadString(const Path: string; Default: string): string; override;
    procedure DoWriteString(const Path: string; Value: string); override;
    function DoReadBinary(const Path: string; var Buf; BufSize: Integer): Integer; override;
    procedure DoWriteBinary(const Path: string; const Buf; BufSize: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function SectionExists(const Path:string; RestorePosition:boolean):boolean;
    function ValueExists(const Section, Key: string; RestorePosition:boolean): boolean;
    function ReadValue(const Section, Key: string): string;virtual;
    procedure WriteValue(const Section, Key, Value: string);virtual;
    procedure StoreDataset;
    procedure RestoreDataset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property KeyField: string read GetKeyField write SetKeyField;
    property SectionField: string read GetSectionField write SetSectionField;
    property ValueField: string read GetValueField write SetValueField;
    property OnRead: TJvDBStorageReadEvent read FOnRead write FOnRead;
    property OnWrite: TJvDBStorageWriteEvent read FOnWrite write FOnWrite;
  end;

  TJvAppDBStorage = class(TJvCustomAppDBStorage)
  published
    property DataSource;
    property KeyField;
    property SectionField;
    property ValueField;

    property OnRead;
    property OnWrite;
  end;

implementation

uses
  JclMime, JvJCLUtils;

resourcestring
  RsENotSupported = 'Method not supported';
  RsEBufTooSmallFmt = 'Buffer too small (%d bytes required)';

{ TJvCustomAppDBStorage }

constructor TJvCustomAppDBStorage.Create(AOwner: TComponent);
begin
  // (p3) create these before calling inherited (AV's otherwise)
  FSectionLink := TFieldDataLink.Create;
  FKeyLink := TFieldDataLink.Create;
  FValueLink := TFieldDataLink.Create;
  inherited Create(AOwner);
end;

procedure TJvCustomAppDBStorage.DeleteSubTreeInt(const Path: string);
begin
  if FieldsAssigned then
  begin
    StoreDataset;
    try
      while SectionExists(Path, False) do
        DataSource.DataSet.Delete;
    finally
      RestoreDataset;
    end;
  end;
end;

procedure TJvCustomAppDBStorage.DeleteValueInt(const Path: string);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  if FieldsAssigned then
  begin
    StoreDataset;
    try
      while ValueExists(Section, Key, False) do
        DataSource.DataSet.Delete;
    finally
      RestoreDataset;
    end;
  end;
end;

destructor TJvCustomAppDBStorage.Destroy;
begin
  FreeAndNil(FSectionLink);
  FreeAndNil(FKeyLink);
  FreeAndNil(FValueLink);
  inherited Destroy;
end;

function TJvCustomAppDBStorage.DoReadBinary(const Path: string; var Buf;
  BufSize: Integer): Integer;
var
  Value: string;
begin
  raise EJvAppDBStorageError.Create(RsENotSupported);
  // TODO -cTESTING -oJVCL: NOT TESTED!!!
  Value := JclMime.MimeDecodeString(DoReadString(Path, ''));
  Result := Length(Value);
  if Result > BufSize then
    raise EJvAppDBStorageError.CreateFmt(RsEBufTooSmallFmt,[Result]);
  if (Length(Value) > 0) then
    Move(Value[1], Buf, Result);
end;

function TJvCustomAppDBStorage.DoReadFloat(const Path: string;
  Default: Extended): Extended;
begin
  Result := StrToFloatDef(DoReadString(Path, ''), Default);
end;

function TJvCustomAppDBStorage.DoReadInteger(const Path: string;
  Default: Integer): Integer;
begin
  Result := StrToIntDef(DoReadString(Path, ''), Default);
end;

function TJvCustomAppDBStorage.DoReadString(const Path: string;
  Default: string): string;
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  Result := ReadValue(Section, Key);
  if Result = '' then
    Result := Default;
end;

procedure TJvCustomAppDBStorage.DoWriteBinary(const Path: string;
  const Buf; BufSize: Integer);
var
  Value, Buf1: string;
begin
  raise EJvAppDBStorageError.Create(RsENotSupported);
  // TODO -cTESTING -oJVCL: NOT TESTED!!!
  SetLength(Value, BufSize);
  if BufSize > 0 then
  begin
    SetLength(Buf1, BufSize);
    Move(Buf, Buf1[1], BufSize);
    JclMime.MimeEncode(Buf1[1], BufSize, Value[1]);
    DoWriteString(Path, Value);
  end;
end;

procedure TJvCustomAppDBStorage.DoWriteFloat(const Path: string;
  Value: Extended);
begin
  DoWriteString(Path, FloatToStr(Value));
end;

procedure TJvCustomAppDBStorage.DoWriteInteger(const Path: string;
  Value: Integer);
begin
  DoWriteString(Path, IntToStr(Value));
end;

procedure TJvCustomAppDBStorage.DoWriteString(const Path: string;
  Value: string);
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  WriteValue(Section, Key, Value);
end;

procedure TJvCustomAppDBStorage.EnumFolders(const Path: string;
  const Strings: TStrings; const ReportListAsValue: Boolean);
begin
  raise EJvAppDBStorageError.Create(RsENotSupported);
end;

procedure TJvCustomAppDBStorage.EnumValues(const Path: string;
  const Strings: TStrings; const ReportListAsValue: Boolean);
begin
  raise EJvAppDBStorageError.Create(RsENotSupported);
end;

function TJvCustomAppDBStorage.FieldsAssigned: boolean;
begin
  Result := (FSectionLink.Field <> nil) and (FKeyLink.Field <> nil) and (FValueLink.Field <> nil);
end;

function TJvCustomAppDBStorage.GetDataSource: TDataSource;
begin
  Result := FSectionLink.DataSource;
end;

function TJvCustomAppDBStorage.GetKeyField: string;
begin
  Result := FKeyLink.FieldName;
end;

function TJvCustomAppDBStorage.GetSectionField: string;
begin
  Result := FSectionLink.FieldName;
end;

function TJvCustomAppDBStorage.GetValueField: string;
begin
  Result := FValueLink.FieldName;
end;

function TJvCustomAppDBStorage.IsFolderInt(Path: string;
  ListIsValue: Boolean): Boolean;
begin
  { TODO -oJVCL -cTESTING : Is this correct implementation? }
  Result := SectionExists(Path, True);
end;

procedure TJvCustomAppDBStorage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if AComponent = DataSource then
    DataSource := nil;
end;

function TJvCustomAppDBStorage.PathExistsInt(const Path: string): boolean;
begin
  { TODO -oJVCL -cTESTING : Is this correct implementation? }
  Result := SectionExists(Path, True);
end;

function TJvCustomAppDBStorage.ReadValue(const Section,
  Key: string): string;
begin
  if ValueExists(Section, Key, False) then
    Result := FValueLink.Field.AsString
  else
    Result := '';
  // always call event
  if Assigned(FOnRead) then
    FOnRead(Self, Section, Key, Result);
end;

procedure TJvCustomAppDBStorage.RemoveValue(const Section, Key: string);
begin
{ TODO -oJVCL -cTESTING : NOT TESTED!!! }
  if ValueExists(Section,Key, False) then
    FValueLink.Field.Clear;
end;

procedure TJvCustomAppDBStorage.RestoreDataset;
begin
  if FBookmark = '' then Exit;
  if FieldsAssigned then
    Datasource.Dataset.Bookmark := FBookmark;
  FBookmark := '';
end;

function TJvCustomAppDBStorage.SectionExists(const Path: string; RestorePosition:boolean): boolean;
begin
  Result := FieldsAssigned and DataSource.Dataset.Active;
  if Result then
  begin
    if RestorePosition then
      StoreDataset;
    try
      Result := DataSource.Dataset.Locate(SectionField, Path, [loCaseInsensitive]);
    finally
      if RestorePosition then
        RestoreDataset;
    end;
  end;
end;

procedure TJvCustomAppDBStorage.SetDataSource(const Value: TDataSource);
begin
  if Assigned(FSectionLink) and not (FSectionLink.DataSourceFixed and (csLoading in ComponentState)) then
  begin
    FSectionLink.DataSource := Value;
    FKeyLink.DataSource := Value;
    FValueLink.DataSource := Value;
  end;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TJvCustomAppDBStorage.SetKeyField(const Value: string);
begin
  FKeyLink.FieldName := Value;
end;

procedure TJvCustomAppDBStorage.SetSectionField(const Value: string);
begin
  FSectionLink.FieldName := Value;
end;

procedure TJvCustomAppDBStorage.SetValueField(const Value: string);
begin
  FValueLink.FieldName := Value;
end;

procedure TJvCustomAppDBStorage.StoreDataset;
begin
  if FBookmark <> '' then
    RestoreDataset;
  if FieldsAssigned and Datasource.Dataset.Active then
  begin
    FBookmark := Datasource.Dataset.Bookmark;
    Datasource.Dataset.DisableControls;
  end;
end;

function TJvCustomAppDBStorage.ValueExists(const Section, Key: string; RestorePosition:boolean): boolean;
begin
  Result := FieldsAssigned and DataSource.Dataset.Active;
  if Result then
  begin
    if RestorePosition then
      StoreDataset;
    try
      Result := DataSource.Dataset.Locate(Format('%s;%s', [SectionField, KeyField]), VarArrayOf([Section, Key]), [loCaseInsensitive]);
    finally
      if RestorePosition then
        RestoreDataset;
    end;
  end;
end;

function TJvCustomAppDBStorage.ValueStoredInt(const Path: string): Boolean;
var
  Section: string;
  Key: string;
begin
  SplitKeyPath(Path, Section, Key);
  Result := ValueExists(Section, Key, True);
end;

procedure TJvCustomAppDBStorage.WriteValue(const Section, Key, Value: string);
begin
  if FieldsAssigned then
  begin
    if ValueExists(Section, Key, False) then
    begin
      if AnsiSameStr(FValueLink.Field.AsString, Value) then
        Exit; // don't save if it's the same value (NB: this also skips the event)
      DataSource.Dataset.Edit
    end
    else
      DataSource.Dataset.Append;
    FSectionLink.Field.AsString := Section;
    FKeyLink.Field.AsString := Key;
    FValueLink.Field.AsString := Value;
    DataSource.Dataset.Post;
  end;
  // always call event
  if Assigned(FOnWrite) then
    FOnWrite(Self, Section, Key, Value);
end;


end.

