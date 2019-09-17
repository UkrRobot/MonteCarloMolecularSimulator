object MainForm: TMainForm
  Left = 114
  Top = 315
  BorderStyle = bsSingle
  Caption = 'Monte Carlo Molecul Simulator'
  ClientHeight = 341
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ImagePanel: TPanel
    Left = 10
    Top = 10
    Width = 321
    Height = 321
    Hint = 'These are the atoms'
    BevelOuter = bvLowered
    Color = clWhite
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object AtomView: TImage
      Left = 0
      Top = 0
      Width = 321
      Height = 321
      ParentShowHint = False
      ShowHint = False
    end
  end
  object StartButton: TButton
    Left = 340
    Top = 300
    Width = 71
    Height = 31
    Hint = 'Start/Stop simulation'
    Caption = 'Go'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = StartButtonClick
  end
  object ResetButton: TButton
    Left = 500
    Top = 300
    Width = 71
    Height = 31
    Hint = 'Reset the position of atoms'
    Caption = 'Reset'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ResetButtonClick
  end
  object QuitButton: TButton
    Left = 610
    Top = 300
    Width = 71
    Height = 31
    Hint = 'Close this application'
    Cancel = True
    Caption = 'Quit'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = QuitButtonClick
  end
  object OneFrameButton: TButton
    Left = 420
    Top = 300
    Width = 71
    Height = 31
    Hint = 'Simulate one frame'
    Caption = 'One Frame'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = OneFrameButtonClick
  end
  object AdditionalPages: TPageControl
    Left = 340
    Top = 10
    Width = 340
    Height = 281
    ActivePage = ParametersTab
    DragKind = dkDock
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = AdditionalPagesChange
    object ParametersTab: TTabSheet
      Caption = 'Parameters'
      object PeriodicBorderSwitch: TSpeedButton
        Left = 230
        Top = 210
        Width = 91
        Height = 31
        Hint = 'Set periodic boundary conditions'
        GroupIndex = 1
        Caption = 'Periodic'
        ParentShowHint = False
        ShowHint = True
        OnClick = PeriodicBorderSwitchClick
      end
      object FixedBorderSwitch: TSpeedButton
        Left = 130
        Top = 210
        Width = 91
        Height = 31
        Hint = 'Set fixed boundary conditions'
        GroupIndex = 1
        Down = True
        Caption = 'Fixed'
        ParentShowHint = False
        ShowHint = True
        OnClick = FixedBorderSwitchClick
      end
      object Potential_ELabel: TPanel
        Left = 0
        Top = 30
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Potential depth, K'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Potential_DLabel: TPanel
        Left = 0
        Top = 60
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Potential minimum'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object Potential_EEdit: TPanel
        Left = 130
        Top = 30
        Width = 121
        Height = 21
        Hint = 'The depth of the potential hole, K'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object Potential_DEdit: TPanel
        Left = 130
        Top = 60
        Width = 121
        Height = 21
        Hint = 'The distance to the minimum of the potential'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object CellSize_2ndLabel: TPanel
        Left = 210
        Top = 90
        Width = 31
        Height = 21
        BevelOuter = bvNone
        Caption = 'by'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object CellsizeYEdit: TPanel
        Left = 250
        Top = 90
        Width = 71
        Height = 21
        Hint = 'Cell height'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object CellsizeXEdit: TPanel
        Left = 130
        Top = 90
        Width = 71
        Height = 21
        Hint = 'Cell width'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object CellSizeLabel: TPanel
        Left = 0
        Top = 90
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Cell size'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
      end
      object SPFLabel: TPanel
        Left = 0
        Top = 120
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Steps per frame'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
      end
      object SPFEdit: TEdit
        Left = 130
        Top = 120
        Width = 121
        Height = 21
        Hint = 'Steps per frame'
        AutoSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnKeyPress = TemperatureEditKeyPress
      end
      object SPFApplyButton: TButton
        Left = 260
        Top = 120
        Width = 61
        Height = 21
        Hint = 'Apply new steps per frame value'
        Caption = 'Apply'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnClick = SPFApplyButtonClick
      end
      object ApplyShiftButton: TButton
        Left = 260
        Top = 150
        Width = 61
        Height = 21
        Hint = 'Apply new maximum displacement distance'
        Caption = 'Apply'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = ApplyShiftButtonClick
      end
      object ShiftEdit: TEdit
        Left = 130
        Top = 150
        Width = 121
        Height = 21
        Hint = 'Maximum displacement distance'
        AutoSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnKeyPress = TemperatureEditKeyPress
      end
      object ShiftLabel: TPanel
        Left = 0
        Top = 150
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Shift distance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 13
      end
      object TemperatureLabel: TPanel
        Left = 0
        Top = 180
        Width = 121
        Height = 21
        BevelOuter = bvNone
        Caption = 'Temperature, K'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 14
      end
      object TemperatureEdit: TEdit
        Left = 130
        Top = 180
        Width = 121
        Height = 21
        Hint = 'System temperature, K'
        AutoSelect = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnKeyPress = TemperatureEditKeyPress
      end
      object ApplyTemperatureButton: TButton
        Left = 260
        Top = 180
        Width = 61
        Height = 21
        Hint = 'Apply new temperature value'
        Caption = 'Apply'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = TemperatureEditChange
      end
      object BoundaryLabel: TPanel
        Left = 0
        Top = 210
        Width = 121
        Height = 31
        BevelOuter = bvNone
        Caption = 'Boundary'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 17
      end
      object ParametersLabel: TPanel
        Left = 0
        Top = 0
        Width = 319
        Height = 21
        BevelOuter = bvNone
        Caption = 'Simulation parameters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 18
      end
      object Edit1: TEdit
        Left = 264
        Top = 32
        Width = 49
        Height = 21
        TabOrder = 19
        Text = '100'
      end
    end
    object StatisticsTab: TTabSheet
      Caption = 'Statistics'
      ImageIndex = 1
      object StepsLabel: TPanel
        Left = 0
        Top = 10
        Width = 151
        Height = 21
        BevelOuter = bvNone
        Caption = 'Simulation steps'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object StepsView: TPanel
        Left = 160
        Top = 10
        Width = 161
        Height = 21
        Hint = 'Total count of simulation steps'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object EnergyLabel: TPanel
        Left = 0
        Top = 40
        Width = 151
        Height = 21
        BevelOuter = bvNone
        Caption = 'Mean energy per atom, K'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
      object MeanEnergyView: TPanel
        Left = 160
        Top = 40
        Width = 161
        Height = 21
        Hint = 'Mean energy per atom, K'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object MinEnergyLabel: TPanel
        Left = 0
        Top = 70
        Width = 151
        Height = 21
        BevelOuter = bvNone
        Caption = 'Minimal energy, K'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object MinEnergyView: TPanel
        Left = 160
        Top = 70
        Width = 161
        Height = 21
        Hint = 'Atom'#39's minimal energy, K'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object MaxEnergyLabel: TPanel
        Left = 0
        Top = 100
        Width = 151
        Height = 21
        BevelOuter = bvNone
        Caption = 'Maximal energy, K'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object MaxEnergyView: TPanel
        Left = 160
        Top = 100
        Width = 161
        Height = 21
        Hint = 'Atom'#39's maximal energy, K'
        Alignment = taLeftJustify
        BevelInner = bvLowered
        BevelOuter = bvLowered
        Color = clWindow
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
    end
    object GRTab: TTabSheet
      Caption = 'Radial distribution'
      ImageIndex = 2
      object GRPanel: TPanel
        Left = 0
        Top = 0
        Width = 331
        Height = 251
        Hint = 'g(r), the radial distribution'
        BevelOuter = bvLowered
        Color = clWhite
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object GRView: TImage
          Left = 0
          Top = 0
          Width = 331
          Height = 251
          HelpContext = 1
          ParentShowHint = False
          ShowHint = False
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Enerdy distribution'
      ImageIndex = 3
      object EnergyPanel: TPanel
        Left = 0
        Top = 0
        Width = 331
        Height = 251
        Hint = 'Energy distribution across atoms'
        BevelOuter = bvLowered
        Color = clWhite
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object EnergyView: TImage
          Left = 0
          Top = 0
          Width = 331
          Height = 251
          HelpContext = 1
          ParentShowHint = False
          ShowHint = False
        end
      end
    end
  end
end
