class MonitoredData {
  dynamic sId;
  dynamic t;
  dynamic d;
  dynamic u;
  dynamic p;
  dynamic f;
  dynamic l;
  dynamic timestamp;
  dynamic iV;

  MonitoredData({
    this.sId,
    this.t,
    this.d,
    this.u,
    this.p,
    this.f,
    this.l,
    this.timestamp,
    this.iV,
  });

  MonitoredData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    t = json['T'];
    d = json['D'];
    u = json['U'];
    p = json['P'];
    f = json['F'];
    l = json['L'];
    timestamp = json['timestamp'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['T'] = t;
    data['D'] = d;
    data['U'] = u;
    data['P'] = p;
    data['F'] = f;
    data['L'] = l;
    data['timestamp'] = timestamp;
    data['__v'] = iV;
    return data;
  }
}
