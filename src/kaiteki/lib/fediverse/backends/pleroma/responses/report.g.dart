// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaReportResponse _$PleromaReportResponseFromJson(
        Map<String, dynamic> json) =>
    PleromaReportResponse(
      total: json['total'] as int,
      reports: (json['reports'] as List<dynamic>)
          .map((e) => PleromaReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PleromaReportResponseToJson(
        PleromaReportResponse instance) =>
    <String, dynamic>{
      'total': instance.total,
      'reports': instance.reports,
    };
