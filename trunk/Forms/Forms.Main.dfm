object fMain: TfMain
  Left = 0
  Top = 0
  ClientHeight = 632
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 28
  object cSelectDrive: TComboBox
    Left = 0
    Top = 0
    Width = 183
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = csDropDownList
    TabOrder = 0
    OnChange = cSelectDriveChange
  end
  object tValues: TTabControl
    Left = 49
    Top = 61
    Width = 365
    Height = 243
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    Tabs.Strings = (
      'Basic'
      'Driver'
      'Critical'
      'SMART')
    TabIndex = 0
    OnChange = tValuesChange
    object gValues: TStringGrid
      Left = 21
      Top = 42
      Width = 405
      Height = 151
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ColCount = 3
      DefaultColWidth = 400
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      TabOrder = 0
      OnClick = gValuesClick
      RowHeights = (
        24
        24)
    end
  end
end
