{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    edStart: TEdit;
    edEnd: TEdit;
    btnGetDirections: TButton;
    lblStart: TLabel;
    lblEnd: TLabel;
    pnlURL: TPanel;
    edURL: TEdit;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    ListView1: TListView;
    Memo1: TMemo;
    Splitter2: TSplitter;
    procedure btnGetDirectionsClick(Sender: TObject);
  end;

  procedure XMLtoTreeView(const aXML:String;aTreeView:TTreeView);

var
  frmMain: TfrmMain;

implementation

uses
  XmlDoc, XmlIntf,
  DelphiMaps.GoogleDirections;

{$R *.dfm}

// general function to display any XML data in a TreeView
procedure XMLtoTreeView(const aXML:String;aTreeView:TTreeView);
var
  XMLDocument: IXMLDocument;
  procedure AddNodes(aXMLNode: IXMLNode; aTreeNode: TTreeNode; aIndex:Integer);
  var
    I: Integer;
    LNewNode: TTreeNode;
    LValue: string;
  begin
    if aXMLNode.NodeType in [ntText, ntCData, ntComment] then
    begin
      LValue := aXMLNode.text;
      aTreeNode.Text := aTreeNode.Text + '=' + LValue;
    end
    else
    begin
      LValue := aXMLNode.nodeName;
      LNewNode := aTreeView.Items.AddChild(aTreeNode, LValue);
      for I := 0 to aXMLNode.childNodes.Count - 1 do
        AddNodes(aXMLNode.childNodes[I], LNewNode,I);
    end;
  end;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.XML.Text:= aXML;
  XMLDocument.Active := True;
  try
    aTreeView.Items.BeginUpdate;
    aTreeView.Items.Clear;
    AddNodes(XMLDocument.Node , nil, 0);
    aTreeView.Items[0].Expand(True);
    aTreeView.TopItem := aTreeView.Items[0];
  finally
    aTreeView.Items.EndUpdate;
  end;
end;




procedure TfrmMain.btnGetDirectionsClick(Sender: TObject);
var
  LRequest : TGoogleDirectionsRequest;
  LDirections:IDirections;
  I: Integer;
begin
  // create a request, set its parameters, and get the response from Google
  LRequest                  := TGoogleDirectionsRequest.Create(self);
  LRequest.origin.Text      := edStart.Text;
  LRequest.destination.Text := edEnd.Text;
  edURL.Text                := LRequest.URL;
  LDirections               := LRequest.GetResponse ;

  XMLtoTreeView(LDirections.XML, TreeView1); // show the XML string as a treeview

  // display the result in a memo

  Memo1.Clear;
  Memo1.Lines.Add('Summary:'+ LDirections.Route.Summary );
  Memo1.Lines.Add('Copyrights:'+ LDirections.Route.Copyrights );
  Memo1.Lines.Add('Distance:'+ LDirections.Route.Leg.Distance.Text );
  Memo1.Lines.Add('From:'+ LDirections.Route.Leg.Start_address );
  Memo1.Lines.Add('From:'+ LDirections.Route.Leg.End_address );

  ListView1.Clear;
  for I := 0 to LDirections.Route.Leg.Step.Count-1 do
  begin
    with ListView1.Items.Add do
    begin
      Caption := 'Step '+IntToStr(I+1);
      SubItems.Add(
        Format('(%s,%s)',[
          LDirections.Route.Leg.Step[I].Start_location.Lat,
          LDirections.Route.Leg.Step[I].Start_location.Lng
        ])
       );
      SubItems.Add(
        Format('(%s,%s)',[
          LDirections.Route.Leg.Step[I].End_location.Lat,
          LDirections.Route.Leg.Step[I].End_location.Lng
        ])
       );
      SubItems.Add(LDirections.Route.Leg.Step[I].Duration.Text);
      SubItems.Add(LDirections.Route.Leg.Step[I].Distance.Text);
      SubItems.Add(LDirections.Route.Leg.Step[I].Html_instructions);
    end;
  end;


end;


end.
