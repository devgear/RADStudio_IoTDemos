object dmDataCollector: TdmDataCollector
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 415
  Width = 830
  object KinveyProvider1: TKinveyProvider
    ApiVersion = '3'
    AppKey = 'kid_-1Rk06yIXe'
    AppSecret = '32bafa5ff7524595ae64372a6a7775a1'
    MasterSecret = 'e67de7d6d80641fca98f2ce437d9ee84'
    Left = 64
    Top = 32
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = memUsers
    FieldDefs = <>
    ResponseJSON = beqryUsers
    Left = 64
    Top = 200
  end
  object memUsers: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = '_id'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'username'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'age'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'sex'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'Height'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'weight'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'Image'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'uuid'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'major'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'minor'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = '_acl'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = '_kmd'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'proximity'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'distance'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 64
    Top = 264
    object memUsers_id: TWideStringField
      FieldName = '_id'
      Size = 255
    end
    object memUsersusername: TWideStringField
      FieldName = 'username'
      Size = 255
    end
    object memUsersage: TWideStringField
      FieldName = 'age'
      Size = 255
    end
    object memUserssex: TWideStringField
      FieldName = 'sex'
      Size = 255
    end
    object memUsersHeight: TWideStringField
      FieldName = 'Height'
      Size = 255
    end
    object memUsersweight: TWideStringField
      FieldName = 'weight'
      Size = 255
    end
    object memUsersImage: TWideStringField
      FieldName = 'Image'
      Size = 255
    end
    object memUsersuuid: TWideStringField
      FieldName = 'uuid'
      Size = 255
    end
    object memUsersmajor: TWideStringField
      FieldName = 'major'
      Size = 255
    end
    object memUsersminor: TWideStringField
      FieldName = 'minor'
      Size = 255
    end
    object memUsers_acl: TWideStringField
      FieldName = '_acl'
      Size = 255
    end
    object memUsers_kmd: TWideStringField
      FieldName = '_kmd'
      Size = 255
    end
    object memUsersproximity: TStringField
      FieldName = 'proximity'
    end
    object memUsersdistance: TStringField
      FieldName = 'distance'
    end
  end
  object beqryUsers: TBackendQuery
    Provider = KinveyProvider1
    BackendClassName = 'Users'
    BackendService = 'Users'
    Left = 64
    Top = 120
  end
  object TetheringManager: TTetheringManager
    OnEndManagersDiscovery = TetheringManagerEndManagersDiscovery
    OnEndProfilesDiscovery = TetheringManagerEndProfilesDiscovery
    OnRequestManagerPassword = TetheringManagerRequestManagerPassword
    OnRemoteManagerShutdown = TetheringManagerRemoteManagerShutdown
    Password = '1234'
    Text = 'TetheringManager'
    AllowedAdapters = 'Network'
    Left = 536
    Top = 24
  end
  object TetheringAppProfile: TTetheringAppProfile
    Manager = TetheringManager
    OnDisconnect = TetheringAppProfileDisconnect
    Text = 'TetheringAppProfile'
    Actions = <>
    Resources = <>
    OnResourceReceived = TetheringAppProfileResourceReceived
    Left = 656
    Top = 24
  end
  object memBeacons: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'major'
        DataType = ftSmallint
      end
      item
        Name = 'minor'
        DataType = ftSmallint
      end
      item
        Name = 'distance'
        DataType = ftFloat
      end>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 2147483647
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 176
    Top = 264
    Content = {
      414442530F00C5166E010000FF00010001FF02FF030400140000006D0065006D
      0042006500610063006F006E00730005000A0000005400610062006C00650006
      00000000000700000800000000000900320000000A0000FF0BFF0C04000A0000
      006D0061006A006F00720005000A0000006D0061006A006F0072000D00010000
      000F000E0010000111000112000113000114000115000116000A0000006D0061
      006A006F007200FEFF0C04000A0000006D0069006E006F00720005000A000000
      6D0069006E006F0072000D00020000000F000E00100001110001120001130001
      14000115000116000A0000006D0069006E006F007200FEFF0C04001000000064
      0069007300740061006E0063006500050010000000640069007300740061006E
      00630065000D00030000000F0017001000011100011200011300011400011500
      01160010000000640069007300740061006E0063006500FEFEFF18FEFF19FEFF
      1AFEFEFEFF1BFEFF1CFF1DFEFEFE0E004D0061006E0061006700650072001E00
      5500700064006100740065007300520065006700690073007400720079001200
      5400610062006C0065004C006900730074000A005400610062006C0065000800
      4E0061006D006500140053006F0075007200630065004E0061006D0065000A00
      54006100620049004400240045006E0066006F0072006300650043006F006E00
      730074007200610069006E00740073000C004C006F00630061006C0065001E00
      4D0069006E0069006D0075006D00430061007000610063006900740079001800
      43006800650063006B004E006F0074004E0075006C006C00140043006F006C00
      75006D006E004C006900730074000C0043006F006C0075006D006E0010005300
      6F007500720063006500490044000E006400740049006E007400310036001000
      4400610074006100540079007000650014005300650061007200630068006100
      62006C006500120041006C006C006F0077004E0075006C006C00080042006100
      7300650014004F0041006C006C006F0077004E0075006C006C0012004F004900
      6E0055007000640061007400650010004F0049006E0057006800650072006500
      1A004F0072006900670069006E0043006F006C004E0061006D00650010006400
      740044006F00750062006C0065001C0043006F006E0073007400720061006900
      6E0074004C00690073007400100056006900650077004C006900730074000E00
      52006F0077004C006900730074001800520065006C006100740069006F006E00
      4C006900730074001C0055007000640061007400650073004A006F0075007200
      6E0061006C000E004300680061006E00670065007300}
    object memBeaconsmajor: TSmallintField
      FieldName = 'major'
    end
    object memBeaconsminor: TSmallintField
      FieldName = 'minor'
    end
    object memBeaconsdistance: TFloatField
      FieldName = 'distance'
    end
  end
  object FDLocalSQL1: TFDLocalSQL
    Connection = FDConnection1
    Active = True
    DataSets = <
      item
        DataSet = memUsers
        Name = 'USERS'
      end
      item
        DataSet = memBeacons
        Name = 'BEACONS'
      end>
    Left = 480
    Top = 200
  end
  object qryBeaconUsers: TFDQuery
    Active = True
    IndexFieldNames = 'distance'
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT username, image, BEACONS.distance, USERS.major, USERS.min' +
        'or FROM USERS, BEACONS'
      
        'WHERE USERS.major = BEACONS.major AND USERS.minor = BEACONS.mino' +
        'r')
    Left = 480
    Top = 256
    object qryBeaconUsersusername: TWideStringField
      FieldName = 'username'
      Origin = 'username'
      Size = 255
    end
    object qryBeaconUsersImage: TWideStringField
      FieldName = 'Image'
      Origin = 'Image'
      Size = 255
    end
    object qryBeaconUsersdistance: TFloatField
      AutoGenerateValue = arDefault
      FieldName = 'distance'
      Origin = 'distance'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '0.##'
    end
    object qryBeaconUsersmajor: TWideStringField
      FieldName = 'major'
      Origin = 'major'
      Size = 255
    end
    object qryBeaconUsersminor: TWideStringField
      FieldName = 'minor'
      Origin = 'minor'
      Size = 255
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 477
    Top = 152
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    ScreenCursor = gcrDefault
    Left = 576
    Top = 152
  end
  object bestrgWeight: TBackendStorage
    Provider = KinveyProvider1
    Left = 160
    Top = 120
  end
  object beqryWeight: TBackendQuery
    Provider = KinveyProvider1
    BackendClassName = 'weightdata'
    BackendService = 'Storage'
    Left = 304
    Top = 120
  end
  object RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter
    Dataset = memWeightData
    FieldDefs = <>
    ResponseJSON = beqryWeight
    Left = 304
    Top = 192
  end
  object memWeightData: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 304
    Top = 264
  end
  object FDQueryIds: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM USERS where major = :MAJOR and minor = :MINOR')
    Left = 600
    Top = 256
    ParamData = <
      item
        Name = 'MAJOR'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'MINOR'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
  end
  object FDQueryUsename: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM USERS WHERE username = :username')
    Left = 600
    Top = 312
    ParamData = <
      item
        Name = 'USERNAME'
        DataType = ftString
        ParamType = ptInput
        Value = #44608#54788#49688
      end>
  end
  object memHRD: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 304
    Top = 343
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 384
    Top = 343
  end
end
