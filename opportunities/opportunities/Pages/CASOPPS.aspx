<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
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

     
   </head>

<body>
    <div class="panel" data-role="panel">
    <div class="heading">
        <span class="title">Opportunities</span>
    </div>
    <h2>Total Opportunities (<span data-bind="text: seats().length"></span>)</h2>
<h4>
Distribution by Quarter:
    <table>
        <thead>
            <tr data-bind="foreach: availableMeals">
                <th><span data-bind="text: mealName"></span></th>
            </tr>
        </thead>
        <tbody>
            <tr data-bind="foreach: mealDistribution">
                <td data-bind="text: ($data * 100).toFixed(2) + '%'"></td>
            </tr>
        </tbody>
    </table>
</h4>
<table>
    <thead><tr>
        <th>Passenger name</th><th>Meal</th><th>Surcharge</th><th></th>
    </tr></thead>
    <tbody data-bind="foreach: seats">
        <tr>
            <td><input data-bind="value: name" /></td>
            <td><select data-bind="options: $root.availableMeals, value: meal, optionsText: 'mealName'"></select></td>
            <td data-bind="text: Quarter_x0020_Forecasted"></td>
            <td><a href="#" data-bind="click: $root.removeSeat">Remove</a></td>
        </tr>    
    </tbody>
</table>

<button data-bind="click: addSeat, enable: seats().length < 7">Reserve another seat</button>

<h3 data-bind="visible: totalSurcharge() > 0">
    Total surcharge: $<span data-bind="text: totalSurcharge().toFixed(2)"></span>
</h3>
          
</body>
</html>
