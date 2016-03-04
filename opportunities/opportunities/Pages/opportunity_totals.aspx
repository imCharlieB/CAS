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
    <script src="../Scripts/App.js"></script>
    <script src="../Scripts/oppgrptotal.js"></script>
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

    <%-- Internal blog --%>
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
            // resources are in URLs in the form:
            // web_url/_layouts/15/resource
            var scriptbase = hostweburl + "/_layouts/15/";
            // Load the js files and continue to the successHandler
            $.getScript(scriptbase + "SP.RequestExecutor.js", execCrossDomainRequest);
        });
        // Function to prepare and issue the request to get
        //  SharePoint data
        function execCrossDomainRequest() {
            // executor: The RequestExecutor object
            // Initialize the RequestExecutor with the app web URL.
            var executor = new SP.RequestExecutor(appweburl);
            // Issue the call against the app web.
            // To get the title using REST we can hit the endpoint:
            //      appweburl/_api/web/lists/getbytitle('listname')/items
            // The response formats the data in the JSON format.
            // The functions successHandler and errorHandler attend the
            //      sucess and error events respectively.
            executor.executeAsync(
                {
                    url: appweburl + "/_api/SP.AppContextSite(@target)/web/lists/getbytitle('opportunities')/items?@target='" + hostweburl + "/'&$top=2",
                    method: "GET",
                    headers: { "Accept": "application/json; odata=verbose" },
                    success: successHandler,
                    error: errorHandler
                }
            );
        }
        // Function to handle the success event.
        // Prints the data to the page.
        function successHandler(data) {
            var jsonObject = JSON.parse(data.body);
            var rmaHTML = "";
            var total = "";
            var results = jsonObject.d.results;
            for (var i = 0; i < results.length; i++) {
                rmaHTML = rmaHTML + "<div><a href=\"" + hostweburl + "/Lists/Opportunities/DispForm.aspx?ID=" + results[i].ID + "\" target=\"_blank\">" + results[i].Account + results[i].OpportunityTotal + "</a></div><br>";
                total = total + "results[i].OpportunityTotal";
            }

            $('#internal').append(rmaHTML);
            $('#opptotal').append(total);
        }

        // Function to handle the error event.
        // Prints the error message to the page.
        function errorHandler(data, errorCode, errorMessage) {
            document.getElementById("internal").innerText =
                "Could not complete cross-domain call: " + errorMessage;
        }
        // Function to retrieve a query string value.
        // For production purposes you may want to use
        //  a library to handle the query string.
        function getQueryStringParameter(paramToRetrieve) {
            var params =
                document.URL.split("?")[1].split("&");
            var strParams = "";
            for (var i = 0; i < params.length; i = i + 1) {
                var singleParam = params[i].split("=");
                if (singleParam[0] == paramToRetrieve)
                    return singleParam[1];
            }
        }
    </script>
   </head>

<body>
    <div class="panel" data-role="panel">
    <div class="heading">
        <span class="title">2016 Q1</span>
    </div>
    <div class="content">
        <div id="internal"></div>
        <div id="opptotal"></div>
        <div id="Opptotals"></div>

       <ul data-bind="foreach:opps">
    <li>
    <input data-bind="value: name" />
        <input data-bind="value: amount" />
        <select data-bind="options: $root.quarter, value: type"></select>
        <a href="#" data-bind="click: $root.removeOpp"> x </a>
    </li>
</ul>
<button data-bind="click: addOpp">Add Opp</button>

<hr/>

<ul data-bind="foreach: quarter">
    <li>
        <h2 data-bind="text: $data"></h2>
         <ul data-bind="foreach: $root.opps.index.type()[$data]">
            <li data-bind="text: name"></li>
              <li data-bind="text: amount"></li>
                    </ul>
        <hr/>
    </li>
</ul>
 
    </div>
</div>
    
   
</body>
</html>
