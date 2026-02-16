// -------------------------
// Visit Details Model
// -------------------------

class VisitDetailsModel {
  VisitDetailsModel({
    bool? status,
    String? message,
    VisitDetails? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  VisitDetailsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? VisitDetails.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  VisitDetails? _data;

  bool? get status => _status;
  String? get message => _message;
  VisitDetails? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) map['data'] = _data?.toJson();
    return map;
  }
}

// -------------------------
// Visit Details
// -------------------------

class VisitDetails {
  VisitDetails({
    String? id,
    String? clientId,
    String? staffId,
    String? contactName,
    String? department,
    String? priority,
    String? purpose,
    String? status,
    String? createDate,
    String? createdAt,
    String? updatedAt,
    String? visitDate,
    String? startAddress,
    String? stopAddress,
    String? amount,
    String? km,
    String? rateKm,
    String? clientName,
    String? state,
    List<TimelineModel>? timelines,
  }) {
    _id = id;
    _clientId = clientId;
    _staffId = staffId;
    _contactName = contactName;
    _department = department;
    _priority = priority;
    _purpose = purpose;
    _status = status;
    _createDate = createDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _visitDate = visitDate;
    _startAddress = startAddress;
    _stopAddress = stopAddress;
    _amount = amount;
    _km = km;
    _rateKm = rateKm;
    _clientName = clientName;
    _state = state;
    _timelines = timelines ?? [];
  }

  VisitDetails.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _clientId = json['client_id']?.toString();
    _staffId = json['staff_id']?.toString();
    _contactName = json['contact_name'];
    _department = json['department'];
    _priority = json['priority'];
    _purpose = json['purpose'];
    _status = json['status'];
    _createDate = json['create_date'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _visitDate = json['visit_date'];
    _startAddress = json['start_address'];
    _stopAddress = json['stop_address'];
    _amount = json['amount'];
    _km = json['km'];
    _rateKm = json['rate_km'];
    _clientName = json['client_name'];
    _state = json['state'];

    if (json['timelines'] != null) {
      _timelines = (json['timelines'] as List)
          .map((e) => TimelineModel.fromJson(e))
          .toList();
    } else {
      _timelines = [];
    }
  }

  String? _id;
  String? _clientId;
  String? _staffId;
  String? _contactName;
  String? _department;
  String? _priority;
  String? _purpose;
  String? _status;
  String? _createDate;
  String? _createdAt;
  String? _updatedAt;
  String? _visitDate;
  String? _startAddress;
  String? _stopAddress;
  String? _amount;
  String? _km;
  String? _rateKm;
  String? _clientName;
  String? _state;
  List<TimelineModel>? _timelines;

  String? get id => _id;
  String? get clientId => _clientId;
  String? get staffId => _staffId;
  String? get contactName => _contactName;
  String? get department => _department;
  String? get priority => _priority;
  String? get purpose => _purpose;
  String? get status => _status;
  String? get createDate => _createDate;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get visitDate => _visitDate;

  String? get startAddress => _startAddress;
  String? get stopAddress => _stopAddress;
  String? get amount => _amount;
  String? get km => _km;
  String? get rateKm => _rateKm;
  String? get clientName => _clientName;
  String? get state => _state;

  List<TimelineModel>? get timelines => _timelines;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['client_id'] = _clientId;
    map['staff_id'] = _staffId;
    map['contact_name'] = _contactName;
    map['department'] = _department;
    map['priority'] = _priority;
    map['purpose'] = _purpose;
    map['status'] = _status;
    map['create_date'] = _createDate;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['visit_date'] = _visitDate;

    map['start_address'] = _startAddress;
    map['stop_address'] = _stopAddress;
    map['amount'] = _amount;
    map['km'] = _km;
    map['rate_km'] = _rateKm;
    map['client_name'] = _clientName;
    map['state'] = _state;

    if (_timelines != null) {
      map['timelines'] = _timelines?.map((e) => e.toJson()).toList();
    }

    return map;
  }
}

// -------------------------
// Timeline Model
// -------------------------

class TimelineModel {
  TimelineModel({
    String? id,
    String? visiteId,
    String? startAddress,
    String? stopAddress,
    String? visitStart,
    String? visitEnd,
    String? meetingStart,
    String? meetingEnd,
    String? createdAt,
    String? state,
  }) {
    _id = id;
    _visiteId = visiteId;
    _startAddress = startAddress;
    _stopAddress = stopAddress;
    _visitStart = visitStart;
    _visitEnd = visitEnd;
    _meetingStart = meetingStart;
    _meetingEnd = meetingEnd;
    _createdAt = createdAt;
    _state = state;
  }

  TimelineModel.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _visiteId = json['visite_id']?.toString();
    _startAddress = json['start_address']?.toString();
    _stopAddress = json['stop_address']?.toString();
    _visitStart = json['visit_start'];
    _visitEnd = json['visit_end'];
    _meetingStart = json['meeting_start'];
    _meetingEnd = json['meeting_end'];
    _createdAt = json['created_at'];
    _state = json['state'];
  }

  String? _id;
  String? _visiteId;
  String? _startAddress;
  String? _stopAddress;
  String? _visitStart;
  String? _visitEnd;
  String? _meetingStart;
  String? _meetingEnd;
  String? _createdAt;
  String? _state;

  String? get id => _id;
  String? get visiteId => _visiteId;
  String? get startAddress => _startAddress;
  String? get stopAddress => _stopAddress;
  String? get visitStart => _visitStart;
  String? get visitEnd => _visitEnd;
  String? get meetingStart => _meetingStart;
  String? get meetingEnd => _meetingEnd;
  String? get createdAt => _createdAt;
  String? get state => _state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['visite_id'] = _visiteId;
    map['start_address'] = _startAddress;
    map['stop_address'] = _stopAddress;
    map['visit_start'] = _visitStart;
    map['visit_end'] = _visitEnd;
    map['meeting_start'] = _meetingStart;
    map['meeting_end'] = _meetingEnd;
    map['created_at'] = _createdAt;
    map['state'] = _state;
    return map;
  }
}


// class VisitDetailsModel {
//   VisitDetailsModel({
//     bool? status,
//     String? message,
//     VisitDetails? data,
//   }) {
//     _status = status;
//     _message = message;
//     _data = data;
//   }
//
//   VisitDetailsModel.fromJson(dynamic json) {
//     _status = json['status'];
//     _message = json['message'];
//     _data = json['data'] != null ? VisitDetails.fromJson(json['data']) : null;
//   }
//
//   bool? _status;
//   String? _message;
//   VisitDetails? _data;
//
//   bool? get status => _status;
//   String? get message => _message;
//   VisitDetails? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['message'] = _message;
//     if (_data != null) map['data'] = _data?.toJson();
//     return map;
//   }
// }
//
// // -------------------------
// // Visit Details
// // -------------------------
//
// class VisitDetails {
//   VisitDetails({
//     String? id,
//     String? clientId,
//     String? staffId,
//     String? contactName,
//     String? department,
//     String? priority,
//     String? purpose,
//     String? status,
//     String? createDate,
//     String? createdAt,
//     String? updatedAt,
//     String? visitDate,
//     List<TimelineItem>? timelines,
//   }) {
//     _id = id;
//     _clientId = clientId;
//     _staffId = staffId;
//     _contactName = contactName;
//     _department = department;
//     _priority = priority;
//     _purpose = purpose;
//     _status = status;
//     _createDate = createDate;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _visitDate = visitDate;
//     _timelines = timelines ?? [];
//   }
//
//   VisitDetails.fromJson(dynamic json) {
//     _id = json['id']?.toString();
//     _clientId = json['client_id']?.toString();
//     _staffId = json['staff_id']?.toString();
//     _contactName = json['contact_name'];
//     _department = json['department'];
//     _priority = json['priority'];
//     _purpose = json['purpose'];
//     _status = json['status'];
//     _createDate = json['create_date'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _visitDate = json['visit_date'];
//
//     // ---- SAFE TIMELINES ----
//     if (json['timelines'] != null) {
//       _timelines = (json['timelines'] as List)
//           .map((e) => TimelineItem.fromJson(e))
//           .toList();
//     } else {
//       _timelines = [];
//     }
//   }
//
//   String? _id;
//   String? _clientId;
//   String? _staffId;
//   String? _contactName;
//   String? _department;
//   String? _priority;
//   String? _purpose;
//   String? _status;
//   String? _createDate;
//   String? _createdAt;
//   String? _updatedAt;
//   String? _visitDate;
//   List<TimelineItem>? _timelines;
//
//   String? get id => _id;
//   String? get clientId => _clientId;
//   String? get staffId => _staffId;
//   String? get contactName => _contactName;
//   String? get department => _department;
//   String? get priority => _priority;
//   String? get purpose => _purpose;
//   String? get status => _status;
//   String? get createDate => _createDate;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   String? get visitDate => _visitDate;
//
//   List<TimelineItem>? get timelines => _timelines;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['client_id'] = _clientId;
//     map['staff_id'] = _staffId;
//     map['contact_name'] = _contactName;
//     map['department'] = _department;
//     map['priority'] = _priority;
//     map['purpose'] = _purpose;
//     map['status'] = _status;
//     map['create_date'] = _createDate;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['visit_date'] = _visitDate;
//
//     if (_timelines != null) {
//       map['timelines'] = _timelines?.map((e) => e.toJson()).toList();
//     }
//
//     return map;
//   }
// }
//
// // -------------------------
// // Timeline Item
// // -------------------------
//
// class TimelineItem {
//   TimelineItem({
//     String? title,
//     String? date,
//     String? description,
//   }) {
//     _title = title;
//     _date = date;
//     _description = description;
//   }
//
//   TimelineItem.fromJson(dynamic json) {
//     _title = json['title'];
//     _date = json['date'];
//     _description = json['description'];
//   }
//
//   String? _title;
//   String? _date;
//   String? _description;
//
//   String? get title => _title;
//   String? get date => _date;
//   String? get description => _description;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['title'] = _title;
//     map['date'] = _date;
//     map['description'] = _description;
//     return map;
//   }
// }
