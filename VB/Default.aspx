<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v18.2, Version=18.2.16.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function OnBatchEditEndEditing(s, e) {
            CalculateSummary(s, e.rowValues, e.visibleIndex, false);
        }
        function CalculateSummary(grid, rowValues, visibleIndex, isDeleting) {
            var originalValue = grid.batchEditApi.GetCellValue(visibleIndex, "C2");
            var newValue = rowValues[(grid.GetColumnByField("C2").index)].value;
            var dif = isDeleting ? -newValue : newValue - originalValue;
            labelSum.SetValue((parseFloat(labelSum.GetValue()) + dif).toFixed(1));
        }
        function OnBatchEditRowDeleting(s, e) {
            CalculateSummary(s, e.rowValues, e.visibleIndex, true);
        }
        function OnChangesCanceling(s, e) {
            if (s.batchEditApi.HasChanges())
                setTimeout(function () {
                    s.Refresh();
                }, 0);
        }
    </script>
</head>
<body>
    <form id="frmMain" runat="server">
        <dx:ASPxGridView ID="Grid" runat="server" KeyFieldName="ID" OnBatchUpdate="Grid_BatchUpdate"
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting"
            ClientInstanceName="gridView" Theme="Office2010Silver">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="true" />
                <dx:GridViewDataColumn  FieldName="C1" />
                <dx:GridViewDataSpinEditColumn Width="100" FieldName="C2">
                    <FooterTemplate>
                        Sum =
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" ClientInstanceName="labelSum" Text='<%#GetTotalSummaryValue()%>'>
                    </dx:ASPxLabel>
                    </FooterTemplate>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataTextColumn FieldName="C3" />
                <dx:GridViewDataCheckColumn FieldName="C4" />
                <dx:GridViewDataDateColumn FieldName="C5" />
            </Columns>
            <SettingsEditing Mode="Batch" BatchEditSettings-HighlightDeletedRows="false" />
            <Settings ShowFooter="true" />
            <TotalSummary>
                <dx:ASPxSummaryItem SummaryType="Sum" FieldName="C2" Tag="C2_Sum" />
            </TotalSummary>
            <ClientSideEvents BatchEditChangesCanceling="OnChangesCanceling" BatchEditRowDeleting="OnBatchEditRowDeleting" BatchEditEndEditing="OnBatchEditEndEditing" />
        </dx:ASPxGridView>
    </form>
</body>
</html>