unit CommonTypes;

interface

uses
  System.Beacon, System.JSON, System.SysUtils;

type
  TBeaconProximityHelper = record helper for TBeaconProximity
    function ToString: string;
  end;

  TBeaconInfo = record
  private
    FDistance: Single;
    FMinorId: Word;
    FMajorId: Word;
  public
    constructor Create(const AMajorId, AMinorId: Word; ADistance: Single);

    property MajorId: Word read FMajorId;
    property MinorId: Word read FMinorId;
    property Distance: Single read FDistance;
  end;

  TBeaconListJSON = class
  public type
    TNames = record
    public const
      Major = 'major';
      Minor = 'minor';
      Proximity = 'proximity';
      Distance = 'distance';
    end;
  public
    class function BeaconListToJSONStr(const ABeaconList: TBeaconList): string; static;
    class function JSONStrToBeaconInfoArray(const AJSONStr: string): TArray<TBeaconInfo>; static;
  end;

  TBeaconDataName = record
  public const
    BeaconList = 'BEACON_LIST';
    ScaleData = 'SCALE_DATA';
  end;

implementation

uses System.Generics.Collections;

{ TBeaconProximityHelper }

function TBeaconProximityHelper.ToString: string;
begin
  Result := '';
  case Self of
    Immediate: Result := 'Immediate';
    Near: Result := 'Near';
    Far: Result := 'Far';
    Away: Result := 'Away';
    else Result := 'Unknown';
  end;
end;

{ TBeaconListJSON }

class function TBeaconListJSON.BeaconListToJSONStr(
  const ABeaconList: TBeaconList): string;
var
  Beacon: IBeacon;
  LJSONArr: TJSONArray;
  LJSON: TJSONObject;
begin
  LJSONArr := TJSONArray.Create;
  try
    for Beacon in ABeaconList do
    begin
      LJSON := TJSONObject.Create;
      LJSON.AddPair(TNames.Major,     Beacon.Major.ToString);
      LJSON.AddPair(TNames.Minor,     Beacon.Minor.ToString);
//      LJSON.AddPair(TNames.Proximity, Beacon.Proximity.ToString);
      LJSON.AddPair(TNames.Distance,  Beacon.Distance.ToString);
      LJSONArr.Add(LJSON);
    end;

    Result := LJSONArr.ToString;
  finally
    LJSONArr.Free;
  end;
end;

class function TBeaconListJSON.JSONStrToBeaconInfoArray(
  const AJSONStr: string): TArray<TBeaconInfo>;
var
  JSONArray: TJSONArray;
  LValue: TJSONValue;
  LList: TList<TBeaconInfo>;
begin
  LList := TList<TBeaconInfo>.Create;
  try
    JSONArray := TJSONObject.ParseJSONValue(AJSONStr) as TJSONArray;
    for LValue in JSONArray do
      LList.Add(TBeaconInfo.Create(
         LValue.GetValue<Word>(TNames.Major, 0),
         LValue.GetValue<Word>(TNames.Minor, 0),
         LValue.GetValue<Single>(TNames.Distance, 0)
      ));
    Result := LList.ToArray;
  finally
    LList.Free;
  end;
end;

{ TBeaconInfo }

constructor TBeaconInfo.Create(const AMajorId, AMinorId: Word;
  ADistance: Single);
begin
  FMajorId := AMajorId;
  FMinorId := AMinorId;
  FDistance := ADistance;
end;

end.
