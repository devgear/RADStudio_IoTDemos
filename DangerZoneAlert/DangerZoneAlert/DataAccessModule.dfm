object dmDataAccess: TdmDataAccess
  OldCreateOrder = False
  Height = 387
  Width = 429
  object KinveyProvider1: TKinveyProvider
    ApiVersion = '3'
    AppKey = 'kid_-JM3gi9r7g'
    AppSecret = '56c45921b81846a680194e3f0894f4ce'
    MasterSecret = '42e7c5c743b64a3b986839cf2d0a1a31'
    AndroidPush.GCMAppID = '593537437466'
    PushEndpoint = 'SpecificUsersMessage'
    Left = 48
    Top = 32
  end
  object BackendUsers1: TBackendUsers
    Provider = KinveyProvider1
    Left = 48
    Top = 104
  end
  object BackendStorage1: TBackendStorage
    Provider = KinveyProvider1
    Left = 48
    Top = 176
  end
  object NotificationCenter1: TNotificationCenter
    Left = 328
    Top = 40
  end
  object MediaPlayer1: TMediaPlayer
    Left = 232
    Top = 40
  end
  object Beacon1: TBeacon
    MonitorizedRegions = <
      item
        UUID = '{E2C56DB5-DFFB-48D2-B060-D0F5A71096E0}'
        Major = 100
        Minor = 1
      end>
    SPC = 0.500000000000000000
    OnBeaconEnter = Beacon1BeaconEnter
    OnBeaconExit = Beacon1BeaconExit
    Left = 232
    Top = 152
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 328
    Top = 152
  end
  object BackendPush1: TBackendPush
    Provider = KinveyProvider1
    Extras = <>
    Left = 48
    Top = 256
  end
end
