'use strict';

var context = SP.ClientContext.get_current();
var user = context.get_web().get_currentUser();

// This code runs when the DOM is ready and creates a context object which is needed to use the SharePoint object model
$(document).ready(function () {
    getUserName();
});

// This function prepares, loads, and then executes a SharePoint query to get the current users information
function getUserName() {
    context.load(user);
    context.executeQueryAsync(onGetUserNameSuccess, onGetUserNameFail);
}

// This function is executed if the above call is successful
// It replaces the contents of the 'message' element with the user name
function onGetUserNameSuccess() {
    $('#message').text('Hello ' + user.get_title());
}

// This function is executed if the above call fails
function onGetUserNameFail(sender, args) {
    alert('Failed to get user name. Error:' + args.get_message());
}
'use strict';

var hostWebUrl;
var appWebUrl;
var listItems
var completeOppList;

$(document).ready(function () {
    //get the url of app web and host web
    hostWebUrl = QS("SPHostUrl");
    appWebUrl = QS("SPAppWebUrl");

    LoadData();
});

//class for saving the countries and their states
function OppList(OpportunityTotal, Quarter_x0020_Forecasted) {
    var self = this;
    self.OpportunityTotal = (OpportunityTotal);
    self.Quarter_x0020_Forecasted = ko.observable(Quarter_x0020_Forecasted);
    
    }

    //View Model to combine data from list into the format which view expects

function OppListViewModel() {
    var self = this;
    
    self.Opps = ko.observableArray([]);
      
    self.AddOpps = function (OpportunityTotal, Quarter_x0020_Forecasted) {
        self.Opps.push(new OppList(OpportunityTotal, Quarter_x0020_Forecasted));
        }
        }


        //function which apply KO bindings and make a call to SP using CSOM
        function LoadData() {

            completeOppList = new OppListViewModel();

            GetList();

            ko.applyBindings(completeOppList);

        }

        function GetList() {
            var context = new SP.ClientContext(appWebUrl);

            //No need to use SP.RequestExecutor.js for cross domain calls to host web in SP Hosted web
            /* var factory = new SP.ProxyWebRequestExecutorFactory(appWebUrl);
            context.set_webRequestExecutorFactory(factory); */
            var hostContext = new SP.AppContextSite(context, hostWebUrl);
            var list = hostContext.get_web().get_lists().getByTitle("Opportunities");
            var camlQuery = new SP.CamlQuery();
            camlQuery.set_viewXml("<View><Query></Query><RowLimit>0</RowLimit></View>");
            listItems = list.getItems(camlQuery);

            context.load(listItems, "Include(OpportunityTotal, Quarter_x0020_Forecasted)");
            context.executeQueryAsync(ListItemsLoaded, ListItemsFailed);
        }

        function ListItemsLoaded(sender, args) {
            var count = 0;
            count = listItems.get_count();
            $("#Opptotals").text(count);

            var enumerator = listItems.getEnumerator();
            while (enumerator.moveNext()) {
                var currentItem = enumerator.get_current();
                completeOppList.AddOpps(currentItem.get_item("OpportunityTotal"));
            }
        }

        function ListItemsFailed(sender, args) {
            alert(args.get_message());
        }

        function QS(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }



// needs to be tested use for counts maybe
Incomplete: ko.computed(function () {
    var count = 0;
    ko.utils.arrayForEach(mydata.Categories(), function (category) {
        ko.utils.arrayForEach(category.ListItems(), function (item) {
            if (!item.IsActive()) {
                count++;
            }
        });
    });

    return count;
});