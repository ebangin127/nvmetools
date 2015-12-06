object fMain: TfMain
  Left = 0
  Top = 0
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 19
  object cSelectDrive: TComboBox
    Left = 0
    Top = 0
    Width = 145
    Height = 27
    Style = csDropDownList
    TabOrder = 0
    OnChange = cSelectDriveChange
  end
  object tValues: TTabControl
    Left = 39
    Top = 48
    Width = 289
    Height = 193
    TabOrder = 1
    Tabs.Strings = (
      'Basic'
      'Driver'
      'Critical'
      'SMART')
    TabIndex = 0
    OnChange = tValuesChange
    object gValues: TStringGrid
      Left = 17
      Top = 33
      Width = 320
      Height = 120
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
