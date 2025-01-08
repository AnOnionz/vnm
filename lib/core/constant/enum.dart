enum AttendanceType {
  CheckIn('Chấm công vào'),
  CheckOut('Chấm công ra');

  const AttendanceType(this.name);

  final String name;
}

enum VerificationMode {
  all_customers,
  new_customer_only,
  existing_customer_only
}

enum FeatureType {
  attendanceClockingIn(),
  attendanceClockingOut(),
  photography(),
  customerInformationCapturing(),
  multiSubjectMultimediaInformationCapturing(),
  multipleEntitiesQuantityCapturing(),
  historyExchange(),
  sampling(),
  urgency(),
  numericSheet(),
  outOfStockStatus(),
  synchronization(isAssistance: true),
  onlineIndividualSummaryReport(isAssistance: true, isOnline: true),
  onlineTeamSummaryReport(isAssistance: true, isOnline: true),
  onlineTeamAttendanceReport(isAssistance: true, isOnline: true),
  summaryReport(isAssistance: true),
  onlineTeamUrgencyReport(isAssistance: true);

  const FeatureType({this.isAssistance = false, this.isOnline = false});
  final bool isAssistance;
  final bool isOnline;
}

enum SettingType { none, toggle, transfer }

enum ValueType { increase, decrease }

enum StatisticType { individual, outlet, employee }

enum SyncStatus { synced, isNoSynced, isDeleted }

enum ImageType {
  original,
  mobile,
  public,
  thumbnail,
}

enum ProfileStatus { PENDING, APPROVED, REJECTED }

enum GenderStatus {
  MALE(value: 'Nam'),
  FEMALE(value: 'Nữ');

  const GenderStatus({required this.value});
  final String value;
}

enum Marital {
  SINGLE(value: 'Độc thân'),
  MARRIED(value: 'Kết hôn'),
  DIVORCED(value: 'Ly dị');

  const Marital({required this.value});
  final String value;
}

enum DressSize { XXS, XS, S, M, L, XL, XXL, XXXL }

enum EducationLevel {
  PRIMARY_SCHOOL(value: 'Tiểu học'),
  MIDDLE_SCHOOL(value: 'Trung học cơ sở'),
  HIGH_SCHOOL(value: 'Trung học phổ thông'),
  VOCATIONAL_TRAINING(value: 'Trung cấp'),
  ASSOCIATE_DEGREE(value: 'Cao đẳng'),
  BACHELOR_DEGREE(value: 'Đại học'),
  MASTER_DEGREE(value: 'Thạc sĩ'),
  DOCTORAL_DEGREE(value: 'Tiến sĩ'),
  POSTDOCTORAL(value: 'Sau tiến sĩ'),
  OTHER(value: 'Khác');

  const EducationLevel({required this.value});

  final String value;
}

enum DesiredPosition {
  PGPB(value: 'PG/PB'),
  HELPER(value: 'Helper'),
  SUP(value: 'SUP');

  const DesiredPosition({required this.value});

  final String value;
}

enum RecruitmentSource {
  FACEBOOK(value: 'FaceBook'),
  LINKEDIN(value: 'Linkedin'),
  ZALO(value: 'Zalo'),
  TOP_CV(value: 'Top CV'),
  VIETNAM_WORKS(value: 'Vietnamwork'),
  REFERRAL(value: 'Được giới thiệu'),
  OTHER(value: 'Khác');

  const RecruitmentSource({required this.value});

  final String value;
}

enum PhotoType { PORTRAIT, FULLBODY, IDFRONT, IDBACK, CV }

enum QuotaType { order, exchange, purchase }

enum ToastGravity { top, bottom, center }

enum GenericType { integer, decimal }
