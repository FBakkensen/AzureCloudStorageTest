page 50100 "FBAContainerContent"
{

    Caption = 'BSAContainerContent';
    PageType = List;
    SourceTable = "ABS Container Content";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Parent Directory"; Rec."Parent Directory")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Content Length"; Rec."Content Length")
                {
                    ApplicationArea = All;
                }
                field("Content Type"; Rec."Content Type")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = All;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(URI; Rec.URI)
                {
                    ApplicationArea = All;
                }
                field("XML Value"; Rec."XML Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload File';
                Image = New;

                trigger OnAction()
                var
                    FileInStream: InStream;
                    FileName: Text;
                begin
                    UploadIntoStream('Select File', '', '', FileName, FileInStream);
                    ABSOperationResponse := ABSBlobClient.PutBlobBlockBlobStream(FileName, FileInStream);
                    IfErrorThenShow(ABSOperationResponse);

                    RefreshPage();
                end;
            }

            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download File';
                Image = New;

                trigger OnAction()
                var
                    FileInStream: InStream;
                    FileName: Text;
                begin
                    FileName := Rec.Name;
                    ABSOperationResponse := ABSBlobClient.GetBlobAsStream(FileName, FileInStream);
                    IfErrorThenShow(ABSOperationResponse);

                    DownloadFromStream(FileInStream, 'Download file', '', '', FileName);
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                Image = New;

                trigger OnAction()
                var
                    FileName: Text;
                begin
                    FileName := Rec.Name;
                    ABSOperationResponse := ABSBlobClient.DeleteBlob(FileName);
                    IfErrorThenShow(ABSOperationResponse);

                    RefreshPage();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(StorageAccountName, ContainerName, Authorization);

        RefreshPage();
    end;

    local procedure IfErrorThenShow(ABSOperationResponse: Codeunit "ABS Operation Response")
    begin
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    local procedure RefreshPage()
    begin
        ABSOperationResponse := ABSBlobClient.ListBlobs(Rec);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;


    var
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        StorageAccountName: Label '<StorageAccountName>', Locked = true;
        SharedKey: Label '<SharedKey>', Locked = true;
        ContainerName: Label '<ContainerName>';

}
