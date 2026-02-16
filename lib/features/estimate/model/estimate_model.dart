class EstimatesModel {
  EstimatesModel({
    bool? status,
    String? message,
    List<DataField>? overview,
    List<Estimate>? data,
  }) {
    _status = status;
    _message = message;
    _overview = overview;
    _data = data;
  }

  EstimatesModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['overview'] != null) {
      _overview = [];
      json['overview'].forEach((v) {
        _overview?.add(DataField.fromJson(v));
      });
    }
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Estimate.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<DataField>? _overview;
  List<Estimate>? _data;

  bool? get status => _status;
  String? get message => _message;
  List<DataField>? get overview => _overview;
  List<Estimate>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_overview != null) {
      map['overview'] = _overview?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Estimate {
  Estimate({
    String? id,
    String? sent,
    String? dateSent,
    String? clientId,
    String? projectId,
    String? number,
    String? prefix,
    String? numberFormat,
    String? formattedNumber,
    String? dateCreated,
    String? date,
    String? expiryDate,
    String? subTotal,
    String? total,
    String? totalTax,
    String? adjustment,
    String? addedFrom,
    String? status,
    String? clientNote,
    String? adminNote,
    String? discountPercent,
    String? discountTotal,
    String? discountType,
    String? invoiceId,
    String? invoiceDate,
    String? terms,
    String? referenceNo,
    String? showQuantityAs,
    String? currency,
    String? currencySymbol,
    String? currencyName,
    String? currencyplacement,
    String? decimalSeparator,
    String? thousandSeparator,
    String? clientName,
    String? projectName,
    String? addedFromName,
    String? statusName,
  }) {
    _id = id;
    _sent = sent;
    _dateSent = dateSent;
    _clientId = clientId;
    _projectId = projectId;
    _number = number;
    _prefix = prefix;
    _numberFormat = numberFormat;
    _formattedNumber = formattedNumber;
    _dateCreated = dateCreated;
    _date = date;
    _expiryDate = expiryDate;
    _subTotal = subTotal;
    _total = total;
    _totalTax = totalTax;
    _adjustment = adjustment;
    _addedFrom = addedFrom;
    _status = status;
    _clientNote = clientNote;
    _adminNote = adminNote;
    _discountPercent = discountPercent;
    _discountTotal = discountTotal;
    _discountType = discountType;
    _invoiceId = invoiceId;
    _invoiceDate = invoiceDate;
    _terms = terms;
    _referenceNo = referenceNo;
    _showQuantityAs = showQuantityAs;
    _currency = currency;
    _currencySymbol = currencySymbol;
    _currencyName = currencyName;
    _currencyplacement = currencyplacement;
    _decimalSeparator = decimalSeparator;
    _thousandSeparator = thousandSeparator;
    _clientName = clientName;
    _projectName = projectName;
    _addedFromName = addedFromName;
    _statusName = statusName;
  }

  Estimate.fromJson(dynamic json) {
    _id = json['id'];
    _sent = json['sent'];
    _dateSent = json['datesend'];
    _clientId = json['clientid'];
    _projectId = json['project_id'];
    _number = json['number'];
    _prefix = json['prefix'];
    _numberFormat = json['number_format'];
    _formattedNumber = json['formatted_number'];
    _dateCreated = json['datecreated'];
    _date = json['date'];
    _expiryDate = json['expirydate'];
    _subTotal = json['subtotal'];
    _total = json['total'];
    _totalTax = json['total_tax'];
    _adjustment = json['adjustment'];
    _addedFrom = json['addedfrom'];
    _status = json['status'];
    _clientNote = json['clientnote'];
    _adminNote = json['adminnote'];
    _discountPercent = json['discount_percent'];
    _discountTotal = json['discount_total'];
    _discountType = json['discount_type'];
    _invoiceId = json['invoiceid'];
    _invoiceDate = json['invoiced_date'];
    _terms = json['terms'];
    _referenceNo = json['reference_no'];
    _showQuantityAs = json['show_quantity_as'];
    _currency = json['currency'];
    _currencySymbol = json['symbol'];
    _currencyName = json['name'];
    _currencyplacement = json['placement'];
    _decimalSeparator = json['decimal_separator'];
    _thousandSeparator = json['thousand_separator'];
    _clientName = json['client_name'];
    _projectName = json['project_name'];
    _addedFromName = json['addedfrom_name'];
    _statusName = json['status_name'];
  }

  String? _id;
  String? _sent;
  String? _dateSent;
  String? _clientId;
  String? _projectId;
  String? _number;
  String? _prefix;
  String? _numberFormat;
  String? _formattedNumber;
  String? _dateCreated;
  String? _date;
  String? _expiryDate;
  String? _subTotal;
  String? _total;
  String? _totalTax;
  String? _adjustment;
  String? _addedFrom;
  String? _status;
  String? _clientNote;
  String? _adminNote;
  String? _discountPercent;
  String? _discountTotal;
  String? _discountType;
  String? _invoiceId;
  String? _invoiceDate;
  String? _terms;
  String? _referenceNo;
  String? _showQuantityAs;
  String? _currency;
  String? _currencySymbol;
  String? _currencyName;
  String? _currencyplacement;
  String? _decimalSeparator;
  String? _thousandSeparator;
  String? _clientName;
  String? _projectName;
  String? _addedFromName;
  String? _statusName;

  String? get id => _id;
  String? get sent => _sent;
  String? get dateSent => _dateSent;
  String? get clientId => _clientId;
  String? get projectId => _projectId;
  String? get number => _number;
  String? get prefix => _prefix;
  String? get numberFormat => _numberFormat;
  String? get formattedNumber => _formattedNumber;
  String? get dateCreated => _dateCreated;
  String? get date => _date;
  String? get expiryDate => _expiryDate;
  String? get subTotal => _subTotal;
  String? get total => _total;
  String? get totalTax => _totalTax;
  String? get adjustment => _adjustment;
  String? get addedFrom => _addedFrom;
  String? get status => _status;
  String? get clientNote => _clientNote;
  String? get adminNote => _adminNote;
  String? get discountPercent => _discountPercent;
  String? get discountTotal => _discountTotal;
  String? get discountType => _discountType;
  String? get invoiceId => _invoiceId;
  String? get invoiceDate => _invoiceDate;
  String? get terms => _terms;
  String? get referenceNo => _referenceNo;
  String? get showQuantityAs => _showQuantityAs;
  String? get currency => _currency;
  String? get currencySymbol => _currencySymbol;
  String? get currencyName => _currencyName;
  String? get currencyplacement => _currencyplacement;
  String? get decimalSeparator => _decimalSeparator;
  String? get thousandSeparator => _thousandSeparator;
  String? get clientName => _clientName;
  String? get projectName => _projectName;
  String? get addedFromName => _addedFromName;
  String? get statusName => _statusName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sent'] = _sent;
    map['datesend'] = _dateSent;
    map['clientid'] = _clientId;
    map['project_id'] = _projectId;
    map['number'] = _number;
    map['prefix'] = _prefix;
    map['number_format'] = _numberFormat;
    map['formatted_number'] = _formattedNumber;
    map['datecreated'] = _dateCreated;
    map['date'] = _date;
    map['expirydate'] = _expiryDate;
    map['subtotal'] = _subTotal;
    map['total'] = _total;
    map['total_tax'] = _totalTax;
    map['adjustment'] = _adjustment;
    map['addedfrom'] = _addedFrom;
    map['status'] = _status;
    map['clientnote'] = _clientNote;
    map['adminnote'] = _adminNote;
    map['discount_percent'] = _discountPercent;
    map['discount_total'] = _discountTotal;
    map['discount_type'] = _discountType;
    map['invoiceid'] = _invoiceId;
    map['invoiced_date'] = _invoiceDate;
    map['terms'] = _terms;
    map['reference_no'] = _referenceNo;
    map['show_quantity_as'] = _showQuantityAs;
    map['currency'] = _currency;
    map['symbol'] = _currencySymbol;
    map['name'] = _currencyName;
    map['placement'] = _currencyplacement;
    map['decimal_separator'] = _decimalSeparator;
    map['thousand_separator'] = _thousandSeparator;
    map['client_name'] = _clientName;
    map['project_name'] = _projectName;
    map['addedfrom_name'] = _addedFromName;
    map['status_name'] = _statusName;
    return map;
  }
}

class DataField {
  DataField({
    String? status,
    String? total,
    String? percent,
  }) {
    _status = status;
    _total = total;
    _percent = percent;
  }

  DataField.fromJson(dynamic json) {
    _status = json['status'];
    _total = json['total'];
    _percent = json['percent'];
  }

  String? _status;
  String? _total;
  String? _percent;

  String? get status => _status;
  String? get total => _total;
  String? get percent => _percent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['total'] = _total;
    map['percent'] = _percent;
    return map;
  }
}
