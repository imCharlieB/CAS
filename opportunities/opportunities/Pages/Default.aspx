<%-- The following 4 lines are ASP.NET directives needed when using SharePoint components --%>

<%@ Page Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" MasterPageFile="~masterurl/default.master" Language="C#" %>

<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%-- The markup and script in the following Content element will be placed in the <head> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <script src="/_layouts/1033/init.js"></script>
<script src="/_layouts/MicrosoftAjax.js"></script>
<script src="/_layouts/sp.core.js"></script>
<script src="/_layouts/sp.runtime.js"></script>
<script src="/_layouts/sp.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-2.2.1.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-2.2.1.min.js"></script>
    <script type="text/javascript" src="../Sc/jquery.SPServices-2013.01.min.js"></script>
    <script type="text/javascript" src="../Scripts/datajs-1.1.3.min.js"></script>
    <script type="text/javascript" src="../Scripts/knockout-3.4.0.js"></script>
    <script type="text/javascript" src="../Scripts/knockout.wrap.js"></script>
    <SharePoint:ScriptLink name="sp.js" runat="server" OnDemand="true" LoadAfterUI="true" Localizable="false" />
    <meta name="WebPartPageExpansion" content="full" />

    <!-- Add your CSS styles to the following file -->
    <link rel="Stylesheet" type="text/css" href="../Content/App.css" />

    <!-- Add your JavaScript to the following file -->
    <script type="text/javascript" src="../Scripts/App.js"></script>
</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Opportunity Totals
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
 
   <h3>All Employees - Knockout Js  and jQuery ( JSON Request )</h3>
    <br />
    <table>
        <thead>
            <tr>
                <th>Amount</th>
                <th>Quarter</th>

            </tr>
        </thead>
        <tbody data-bind="foreach:Opps">
            <tr>
                <td data-bind="text:OpportunityTotal"></td>
                <td data-bind="text:Quarter_x0020_Forecasted"></td>

            </tr>
        </tbody>
    </table>
    <script type="text/javascript">
        var hostweburl;
        var appweburl;
        // Load the required SharePoint libraries
        $(document).ready(function () {
            //Get the URI decoded URLs.
            hostweburl =
                decodeURIComponent(
                    getQueryStringParameter("SPHostUrl")
            );
            appweburl =
                decodeURIComponent(
                    getQueryStringParameter("SPAppWebUrl")
            );
   
     function OppModal() {
         var self = this;
         self.Opps = ko.observableArray([]);
         $.getJSON(_spPageContextInfo.webAbsoluteUrl + "/_vti_bin/listdata.svc/Opportunities?$top=2",
              function (data) {
                  if (data.d) {
                      if (data.d.results)
                          self.Opps(ko.wrap.toJS(data.d.results));
                      else
                          self.Opps(ko.wrap.toJS(data.d));
                  }
              }
         );
     }
     ko.applyBindings(new OppModal());
    </script>

    </asp:Content>
