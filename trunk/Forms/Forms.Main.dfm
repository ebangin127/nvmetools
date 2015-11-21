object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Naraeon NVMe Tools (Refresh - F5)'
  ClientHeight = 400
  ClientWidth = 750
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
  object gValues: TStringGrid
    Left = 184
    Top = 120
    Width = 320
    Height = 120
    ColCount = 3
    DefaultColWidth = 300
    RowCount = 2
    TabOrder = 1
  end
end
