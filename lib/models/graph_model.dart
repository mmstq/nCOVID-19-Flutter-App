class GraphCaseModel {
  String country;
  Cases cases;
  Deaths deaths;
  String day;
  String time;

  GraphCaseModel({this.country, this.cases, this.deaths, this.day, this.time});

  GraphCaseModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    cases =
    json['cases'] != null ? new Cases.fromJson(json['cases']) : null;
    deaths =
    json['deaths'] != null ? new Deaths.fromJson(json['deaths']) : null;
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.cases != null) {
      data['cases'] = this.cases.toJson();
    }
    if (this.deaths != null) {
      data['deaths'] = this.deaths.toJson();
    }
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}

class Cases {
  String newCases;
  int active;
  int critical;
  int recovered;
  int total;

  Cases(
      {this.newCases, this.active, this.critical, this.recovered, this.total});

  Cases.fromJson(Map<String, dynamic> json) {
    newCases = json['new']??'+00';
    active = json['active'];
    critical = json['critical'];
    recovered = json['recovered'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new'] = this.newCases;
    data['active'] = this.active;
    data['critical'] = this.critical;
    data['recovered'] = this.recovered;
    data['total'] = this.total;
    return data;
  }
}

class Deaths {
  String newDeaths;
  int total;

  Deaths({this.newDeaths, this.total});

  Deaths.fromJson(Map<String, dynamic> json) {
    newDeaths = json['new']??'+00';
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new'] = this.newDeaths;
    data['total'] = this.total;
    return data;
  }
}
