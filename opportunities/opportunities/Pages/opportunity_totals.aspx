﻿<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<WebPartPages:AllowFraming ID="AllowFraming" runat="server" />

<html>
<head>
    <title></title>

    <script type="text/javascript" src="../Scripts/jquery-2.2.1.min.js"></script>
    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    <script src="../Scripts/datajs-1.1.3.js"></script>
    <script src="../Scripts/knockout-3.4.0.js"></script>
    <script src="../Scripts/knockout.wrap.js"></script>
    <script src="../Scripts/App.js"></script>
      <script src="../Scripts/metro.js"></script>
      <!-- Add your CSS styles to the following file -->
    <link href="../Content/App.css" rel="stylesheet" />
    <link href="../Content/metro-icons.min.css" rel="stylesheet" />
    <link href="../Content/metro.css" rel="stylesheet" />
    <link href="../Content/metro-responsive.min.css" rel="stylesheet" />
    <script type="text/javascript">
// Set the style of the client web part page to be consistent with the host web.
      
        (function () {
            'use strict';

            var hostUrl = '';
            if (document.URL.indexOf('?') != -1) {
                var params = document.URL.split('?')[1].split('&');
                for (var i = 0; i < params.length; i++) {
                    var p = decodeURIComponent(params[i]);
                    if (/^SPHostUrl=/i.test(p)) {
                        hostUrl = p.split('=')[1];
                        document.write('<link rel="stylesheet" href="' + hostUrl + '/_layouts/15/defaultcss.ashx" />');
                        break;
                    }
                }
            }
            if (hostUrl == '') {
                document.write('<link rel="stylesheet" href="/_layouts/15/1033/styles/themable/corev15.css" />');
            }
        })();
    </script>
</head>

     
  
<body>
    <div class="panel" data-role="panel">
    <div class="heading">
        <span class="title">Opportunities</span>
    </div>
    <div class="content">     
     Quarter: <input data-bind="value: search_Quarter, valueUpdate: 'afterkeydown'" />
          <table class="table">
    <thead>
        <tr>
            <th class="sortable-column sort-asc">Quarter</th>
            <th class="sortable-column">Total</th>
                        </tr>
    </thead>
              <tbody data-bind="foreach: filteredRecords">
           
        <td data-bind="text: Quarter_x0020_Forecasted"></td>
            <td data-bind="text: OpportunityTotal"></td>
        
    </tr>
                         </tbody>
</table>
        <div class="tile-wide bg-lighterblue" data-role="tile" data-effect="slideUpDown">
    <div class="tile-content">
        <div class="live-slide"><h1>Number of Opps: <div id="Opptotals"></div></h1></div>
        <div class="live-slide"><h1> Total value: <span data-bind="text: formatCurrency(grandTotal())"></span> 
    </div></div>
    </div>
</div>
        
        
  <br />
         <div class="listview small">
     <div class="list-content" data-bind="foreach: oppqt">
    <li data-bind="with: $root.Opps.index.Quarter_x0020_Forecasted()[$data]">
        <h2><span data-bind="text: $parent"></span> Total Amount: <span data-bind="text: formatCurrency(total())"></span></h2>
      
    <hr/>

</li>
</div>
</div>
        </div>
</body>
</html>
