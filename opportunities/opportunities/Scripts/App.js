
ko.observableArray.fn.distinctWithTotal = function (prop, totalProp) {
    var target = this;
    target.index = {};
    target.index[prop] = ko.observable({});

    ko.computed(function () {
        //rebuild index
        var propIndex = {};

        ko.utils.arrayForEach(target(), function (item) {
            var key = ko.utils.unwrapObservable(item[prop]);
            if (key) {
                propIndex[key] = propIndex[key] || [];
                propIndex[key].push(item);
            }
        });

        if (totalProp) {
            for (key in propIndex) {
                if (propIndex.hasOwnProperty(key)) {
                    propIndex[key].total = ko.computed(function () {
                        var total = 0;
                        ko.utils.arrayForEach(propIndex[key], function (item) {
                            total += parseInt(ko.utils.unwrapObservable(item[totalProp]), 10) || 0;
                        });

                        return total;
                    });
                }
            }
        }

        target.index[prop](propIndex);
    });

    return target;
};
'use strict';

var context = SP.ClientContext.get_current();
var user = context.get_web().get_currentUser();
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


function formatCurrency(value) {
    return "$" + value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


//class for saving the countries and their states
function OppList(OpportunityTotal, Quarter_x0020_Forecasted) {
    var self = this;
    self.OpportunityTotal = ko.observable(OpportunityTotal);
    self.Quarter_x0020_Forecasted = ko.observable(Quarter_x0020_Forecasted);
    
    }

    //View Model to combine data from list into the format which view expects

function OppListViewModel() {
    var self = this;
    self.search_Quarter = ko.observable('');
    this.oppqt = ko.observableArray(["2016Q1", "2016Q2", "2016Q3", "2016Q4"]);
    self.Opps = ko.observableArray([]).distinctWithTotal('Quarter_x0020_Forecasted', 'OpportunityTotal');
   
    this.grandTotal = ko.computed(function () {
        var total = 0;
        ko.utils.arrayForEach(this.Opps(), function (opp) {
            total += opp.OpportunityTotal();
        });
        return total;
    }, this);

    self.filteredRecords = ko.computed(function () {
        return ko.utils.arrayFilter(self.Opps(), function (rec) {
            return (
                      (self.search_Quarter().length == 0 || rec.Quarter_x0020_Forecasted().toLowerCase().indexOf(self.search_Quarter().toLowerCase()) > -1)
                   )
        });
    });
      
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
            camlQuery.set_viewXml("<View><Query><Where><And><Neq><FieldRef Name='Lead_x0020_Source' /><Value Type='Choice'>Closed Won</Value></Neq><Neq><FieldRef Name='Lead_x0020_Source' /><Value Type='Choice'>Closed Lost</Value></Neq></And></Where></Where></Query><RowLimit>0</RowLimit></View>");
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
                completeOppList.AddOpps(currentItem.get_item("OpportunityTotal"), currentItem.get_item("Quarter_x0020_Forecasted"));
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



