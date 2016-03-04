
'use strict';
$(document).ready(function () {
    //get the url of app web and host web
    hostWebUrl = QS("SPHostUrl");
    appWebUrl = QS("SPAppWebUrl");

   
ko.observableArray.fn.distinct = function (prop) {
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

        target.index[prop](propIndex);
    });

    return target;
};

var Opp = function (name, amount, type) {
    this.name = ko.observable(name);
    this.amount = ko.observable(amount);
    this.type = ko.observable(type);
}


var ViewModel = function () {
    var self = this;
    self.quarter = ["2016Q1", "2016Q2", "Other"];
    self.opps = ko.observableArray([
           new Opp("CAS", "14,000", "2016Q1"),
           new Opp("CAS", "23,000", "2016Q1"),
           new Opp("CAS", "12,000", "2016Q2")
    ]).distinct('type');


    this.addOpp = function () {
        self.opps.push(new Opp("name", "0", "2016Q1"));
    };

    this.removeOpp = function (opp) {
        self.opps.remove(opp);
    };
};


ko.applyBindings(new ViewModel());





});