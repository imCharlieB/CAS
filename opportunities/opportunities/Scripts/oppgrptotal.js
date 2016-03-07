    function Opp(name, amount, type) {
        var self = this;
        self.name = ko.observable(name);
        self.amount = ko.observable(amount);
        self.type = ko.observable(type);

    }


    var ViewModel = function () {
        var self = this;
        self.quarter = ["2016Q1", "2016Q2"];
        self.opps = ko.observableArray([
              new Opp("CAS", "14,000", "2016Q1"),
              new Opp("CAS", "23,000", "2016Q1"),
              new Opp("CAS", "12,000", "2016Q2"),
              new Opp("NewOpp", "52,000", "2016Q2")
        ]);
       
    };

    this.addOpp = function () {
        self.opps.push(new Opp("name", "0", "2016Q1"));
    };

    this.removeOpp = function (opp) {
        self.opps.remove(opp);
    };


    ko.applyBindings(new ViewModel());
