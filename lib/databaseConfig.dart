import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'word.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // 데이터베이스 초기화
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'word_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE words(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            meaning TEXT,
            chapter INTEGER,
            isPreloaded INTEGER DEFAULT 0,
            memorizedStatus INTEGER DEFAULT 0,
            remember INTEGER DEFAULT 0,
            UNIQUE(name, chapter) -- 고유 제약 조건 추가
          )
          ''',
        );

        // 기본 단어 삽입
        await _insertPreloadedWords(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // memorizedStatus 컬럼 추가
          await db.execute('ALTER TABLE words ADD COLUMN memorizedStatus INTEGER DEFAULT 0');
        }
        if (oldVersion < 4) {
          // remember 컬럼 추가
          await db.execute('ALTER TABLE words ADD COLUMN remember INTEGER DEFAULT 0');
        }
        // 추가적인 버전 업그레이드 로직을 여기에 작성
      },
      version: 4, // 데이터베이스 버전을 4로 올림
    );
  }

  // 기본 단어를 삽입하는 메서드
  Future<void> _insertPreloadedWords(Database db) async {
    List<Word> preloadedWords = [
      //chapter 1
      Word(name: 'resume', meaning: '이력서', chapter: 1, isPreloaded: true),
      Word(name: 'opening', meaning: '공석', chapter: 1, isPreloaded: true),
      Word(name: 'applicant', meaning: '지원자', chapter: 1, isPreloaded: true),
      Word(name: 'requirement', meaning: '필요조건', chapter: 1, isPreloaded: true),
      Word(name: 'meet', meaning: '만족시키다', chapter: 1, isPreloaded: true),
      Word(name: 'qualified', meaning: '자격 있는', chapter: 1, isPreloaded: true),
      Word(name: 'candidate', meaning: '후보자', chapter: 1, isPreloaded: true),
      Word(name: 'confidence', meaning: '확신', chapter: 1, isPreloaded: true),
      Word(name: 'highly', meaning: '매우', chapter: 1, isPreloaded: true),
      Word(name: 'professional', meaning: '전문적인', chapter: 1, isPreloaded: true),
      Word(name: 'interview', meaning: '면접', chapter: 1, isPreloaded: true),
      Word(name: 'hire', meaning: '고용하다', chapter: 1, isPreloaded: true),
      Word(name: 'training', meaning: '교육', chapter: 1, isPreloaded: true),
      Word(name: 'reference', meaning: '추천서', chapter: 1, isPreloaded: true),
      Word(name: 'position', meaning: '일자리', chapter: 1, isPreloaded: true),
      Word(name: 'achievement', meaning: '성취', chapter: 1, isPreloaded: true),
      Word(name: 'impressed', meaning: '인상 깊게 생각하는', chapter: 1, isPreloaded: true),
      Word(name: 'excellent', meaning: '훌륭한', chapter: 1, isPreloaded: true),
      Word(name: 'eligible', meaning: '자격이 있는', chapter: 1, isPreloaded: true),
      Word(name: 'identify', meaning: '알아보다', chapter: 1, isPreloaded: true),
      Word(name: 'associate', meaning: '관련시키다', chapter: 1, isPreloaded: true),
      Word(name: 'condition', meaning: '조건', chapter: 1, isPreloaded: true),
      Word(name: 'employment', meaning: '고용', chapter: 1, isPreloaded: true),
      Word(name: 'lack', meaning: '~이 없다', chapter: 1, isPreloaded: true),
      Word(name: 'managerial', meaning: '관리의', chapter: 1, isPreloaded: true),
      Word(name: 'diligent', meaning: '성실한', chapter: 1, isPreloaded: true),
      Word(name: 'familiar', meaning: '익숙한', chapter: 1, isPreloaded: true),
      Word(name: 'proficiency', meaning: '숙달', chapter: 1, isPreloaded: true),
      Word(name: 'prospective', meaning: '장래의', chapter: 1, isPreloaded: true),
      Word(name: 'appeal', meaning: '관심을 끌다', chapter: 1, isPreloaded: true),
      Word(name: 'specialize', meaning: '~을 전공하다', chapter: 1, isPreloaded: true),
      Word(name: 'apprehensive', meaning: '걱정하는', chapter: 1, isPreloaded: true),
      Word(name: 'consultant', meaning: '고문', chapter: 1, isPreloaded: true),
      Word(name: 'entitle', meaning: '자격을 주다', chapter: 1, isPreloaded: true),
      Word(name: 'degree', meaning: '학위', chapter: 1, isPreloaded: true),
      Word(name: 'payroll', meaning: '임금 대장', chapter: 1, isPreloaded: true),
      Word(name: 'recruit', meaning: '모집하다', chapter: 1, isPreloaded: true),
      Word(name: 'certification', meaning: '증명서', chapter: 1, isPreloaded: true),
      Word(name: 'occupation', meaning: '직업', chapter: 1, isPreloaded: true),
      Word(name: 'wage', meaning: '임금', chapter: 1, isPreloaded: true),

      //chapter 2
      Word(name: 'attire', meaning: '복장', chapter: 2, isPreloaded: true),
      Word(name: 'code', meaning: '규범', chapter: 2, isPreloaded: true),
      Word(name: 'concern', meaning: '우려', chapter: 2, isPreloaded: true),
      Word(name: 'policy', meaning: '규정', chapter: 2, isPreloaded: true),
      Word(name: 'comply', meaning: '준수하다', chapter: 2, isPreloaded: true),
      Word(name: 'regulation', meaning: '규정', chapter: 2, isPreloaded: true),
      Word(name: 'exception', meaning: '예외', chapter: 2, isPreloaded: true),
      Word(name: 'adhere', meaning: '지키다', chapter: 2, isPreloaded: true),
      Word(name: 'severely', meaning: '엄격하게', chapter: 2, isPreloaded: true),
      Word(name: 'refrain', meaning: '자제하다', chapter: 2, isPreloaded: true),
      Word(name: 'permission', meaning: '허락', chapter: 2, isPreloaded: true),
      Word(name: 'access', meaning: '이용 권한', chapter: 2, isPreloaded: true),
      Word(name: 'thoroughly', meaning: '철저하게', chapter: 2, isPreloaded: true),
      Word(name: 'revise', meaning: '수정하다', chapter: 2, isPreloaded: true),
      Word(name: 'approach', meaning: '접근법', chapter: 2, isPreloaded: true),
      Word(name: 'approval', meaning: '승인', chapter: 2, isPreloaded: true),
      Word(name: 'form', meaning: '종류', chapter: 2, isPreloaded: true),
      Word(name: 'immediately', meaning: '즉시', chapter: 2, isPreloaded: true),
      Word(name: 'inspection', meaning: '점검', chapter: 2, isPreloaded: true),
      Word(name: 'arrangement', meaning: '준비', chapter: 2, isPreloaded: true),
      Word(name: 'procedure', meaning: '절차', chapter: 2, isPreloaded: true),
      Word(name: 'negative', meaning: '부정적인', chapter: 2, isPreloaded: true),
      Word(name: 'mandate', meaning: '명령하다', chapter: 2, isPreloaded: true),
      Word(name: 'effect', meaning: '효력', chapter: 2, isPreloaded: true),
      Word(name: 'drastically', meaning: '심하게', chapter: 2, isPreloaded: true),
      Word(name: 'according to', meaning: '~에 따라', chapter: 2, isPreloaded: true),
      Word(name: 'enable', meaning: '가능하게 하다', chapter: 2, isPreloaded: true),
      Word(name: 'standard', meaning: '기준', chapter: 2, isPreloaded: true),
      Word(name: 'constant', meaning: '지속적인', chapter: 2, isPreloaded: true),
      Word(name: 'act', meaning: '법령', chapter: 2, isPreloaded: true),
      Word(name: 'compensation', meaning: '보상금', chapter: 2, isPreloaded: true),
      Word(name: 'ban', meaning: '금지', chapter: 2, isPreloaded: true),
      Word(name: 'obligation', meaning: '의무', chapter: 2, isPreloaded: true),
      Word(name: 'authorize', meaning: '~을 인가하다', chapter: 2, isPreloaded: true),
      Word(name: 'prohibit', meaning: '금지하다', chapter: 2, isPreloaded: true),
      Word(name: 'abolish', meaning: '폐지하다', chapter: 2, isPreloaded: true),
      Word(name: 'enforce', meaning: '시행하다', chapter: 2, isPreloaded: true),
      Word(name: 'habit', meaning: '습관', chapter: 2, isPreloaded: true),
      Word(name: 'legislation', meaning: '법률', chapter: 2, isPreloaded: true),
      Word(name: 'restrict', meaning: '한정하다', chapter: 2, isPreloaded: true),

      //chapter 3
      Word(name: 'accustomed', meaning: '익숙한', chapter: 3, isPreloaded: true),
      Word(name: 'corporation', meaning: '주식회사', chapter: 3, isPreloaded: true),
      Word(name: 'demanding', meaning: '요구가 많은', chapter: 3, isPreloaded: true),
      Word(name: 'colleague', meaning: '동료', chapter: 3, isPreloaded: true),
      Word(name: 'division', meaning: '부서', chapter: 3, isPreloaded: true),
      Word(name: 'request', meaning: '요청', chapter: 3, isPreloaded: true),
      Word(name: 'efficiently', meaning: '효율적으로', chapter: 3, isPreloaded: true),
      Word(name: 'manage', meaning: '~을 경영하다', chapter: 3, isPreloaded: true),
      Word(name: 'submit', meaning: '제출하다', chapter: 3, isPreloaded: true),
      Word(name: 'directly', meaning: '곧바로', chapter: 3, isPreloaded: true),
      Word(name: 'remind', meaning: '~에게 상기시키다', chapter: 3, isPreloaded: true),
      Word(name: 'instruct', meaning: '지시하다', chapter: 3, isPreloaded: true),
      Word(name: 'deadline', meaning: '마감일', chapter: 3, isPreloaded: true),
      Word(name: 'sample', meaning: '견본', chapter: 3, isPreloaded: true),
      Word(name: 'notify', meaning: '~에게 통지하다', chapter: 3, isPreloaded: true),
      Word(name: 'perform', meaning: '행하다', chapter: 3, isPreloaded: true),
      Word(name: 'monitor', meaning: '감독하다', chapter: 3, isPreloaded: true),
      Word(name: 'deserve', meaning: '~할 만하다', chapter: 3, isPreloaded: true),
      Word(name: 'assignment', meaning: '일', chapter: 3, isPreloaded: true),
      Word(name: 'entire', meaning: '전체의', chapter: 3, isPreloaded: true),
      Word(name: 'release', meaning: '발표하다', chapter: 3, isPreloaded: true),
      Word(name: 'extension', meaning: '연장', chapter: 3, isPreloaded: true),
      Word(name: 'electronically', meaning: '컴퓨터 통신망으로', chapter: 3, isPreloaded: true),
      Word(name: 'attendance', meaning: '출근', chapter: 3, isPreloaded: true),
      Word(name: 'absolutely', meaning: '절대적으로', chapter: 3, isPreloaded: true),
      Word(name: 'delegate', meaning: '위임하다', chapter: 3, isPreloaded: true),
      Word(name: 'attentively', meaning: '주의 깊게', chapter: 3, isPreloaded: true),
      Word(name: 'supervision', meaning: '감독', chapter: 3, isPreloaded: true),
      Word(name: 'workshop', meaning: '워크숍', chapter: 3, isPreloaded: true),
      Word(name: 'draw', meaning: '끌다', chapter: 3, isPreloaded: true),
      Word(name: 'revision', meaning: '수정', chapter: 3, isPreloaded: true),
      Word(name: 'reluctantly', meaning: '마지못해', chapter: 3, isPreloaded: true),
      Word(name: 'acquaint', meaning: '~에게 숙지시키다', chapter: 3, isPreloaded: true),
      Word(name: 'convey', meaning: '전달하다', chapter: 3, isPreloaded: true),
      Word(name: 'check', meaning: '검사하다', chapter: 3, isPreloaded: true),
      Word(name: 'headquarters', meaning: '본부', chapter: 3, isPreloaded: true),
      Word(name: 'file', meaning: '정리하다', chapter: 3, isPreloaded: true),
      Word(name: 'oversee', meaning: '감독하다', chapter: 3, isPreloaded: true),
      Word(name: 'involved', meaning: '관여하는', chapter: 3, isPreloaded: true),
      Word(name: 'concentrate', meaning: '집중하다', chapter: 3, isPreloaded: true),

      //chapter 4
      Word(name: 'lax', meaning: '느슨한', chapter: 4, isPreloaded: true),
      Word(name: 'procrastionate', meaning: '미루다', chapter: 4, isPreloaded: true),
      Word(name: 'combined', meaning: '결합된', chapter: 4, isPreloaded: true),
      Word(name: 'accomplish', meaning: '성취하다', chapter: 4, isPreloaded: true),
      Word(name: 'voluntarily', meaning: '자발적으로', chapter: 4, isPreloaded: true),
      Word(name: 'undertake', meaning: '떠맡다', chapter: 4, isPreloaded: true),
      Word(name: 'assume', meaning: '사실이라고 생각하다', chapter: 4, isPreloaded: true),
      Word(name: 'occasionally', meaning: '가끔', chapter: 4, isPreloaded: true),
      Word(name: 'employee', meaning: '직원', chapter: 4, isPreloaded: true),
      Word(name: 'assist', meaning: '돕다', chapter: 4, isPreloaded: true),
      Word(name: 'satisfied', meaning: '만족하는', chapter: 4, isPreloaded: true),
      Word(name: 'manner', meaning: '방식', chapter: 4, isPreloaded: true),
      Word(name: 'responsible', meaning: '책임이 있는', chapter: 4, isPreloaded: true),
      Word(name: 'conduct', meaning: '수행하다', chapter: 4, isPreloaded: true),
      Word(name: 'adjust', meaning: '적응하다', chapter: 4, isPreloaded: true),
      Word(name: 'personnel', meaning: '직원', chapter: 4, isPreloaded: true),
      Word(name: 'agree', meaning: '동의하다', chapter: 4, isPreloaded: true),
      Word(name: 'supervise', meaning: '감독하다', chapter: 4, isPreloaded: true),
      Word(name: 'coworker', meaning: '동료', chapter: 4, isPreloaded: true),
      Word(name: 'direct', meaning: '~에게 길을 안내하다', chapter: 4, isPreloaded: true),
      Word(name: 'confidential', meaning: '기밀의', chapter: 4, isPreloaded: true),
      Word(name: 'assign', meaning: '배정하다', chapter: 4, isPreloaded: true),
      Word(name: 'leading', meaning: '선도적인', chapter: 4, isPreloaded: true),
      Word(name: 'formal', meaning: '격식을 갖춘', chapter: 4, isPreloaded: true),
      Word(name: 'remove', meaning: '해임하다', chapter: 4, isPreloaded: true),
      Word(name: 'collect', meaning: '모으다', chapter: 4, isPreloaded: true),
      Word(name: 'coordinate', meaning: '조정하다', chapter: 4, isPreloaded: true),
      Word(name: 'hardly', meaning: '거의 ~하지 않다', chapter: 4, isPreloaded: true),
      Word(name: 'abstract', meaning: '추상적인', chapter: 4, isPreloaded: true),
      Word(name: 'directory', meaning: '주소록', chapter: 4, isPreloaded: true),
      Word(name: 'accountable', meaning: '책임이 있는', chapter: 4, isPreloaded: true),
      Word(name: 'skillfully', meaning: '능숙하게', chapter: 4, isPreloaded: true),
      Word(name: 'exclusive', meaning: '독점적인', chapter: 4, isPreloaded: true),
      Word(name: 'intention', meaning: '의지', chapter: 4, isPreloaded: true),
      Word(name: 'transform', meaning: '바꾸다', chapter: 4, isPreloaded: true),
      Word(name: 'respectful', meaning: '정중한', chapter: 4, isPreloaded: true),
      Word(name: 'duplicate', meaning: '사본', chapter: 4, isPreloaded: true),
      Word(name: 'contrary', meaning: '반대', chapter: 4, isPreloaded: true),
      Word(name: 'disturbing', meaning: '충격적인', chapter: 4, isPreloaded: true),
      Word(name: 'engage', meaning: '관여하다', chapter: 4, isPreloaded: true),
      Word(name: 'foster', meaning: '촉진하다', chapter: 4, isPreloaded: true),
      Word(name: 'neutrality', meaning: '중립성', chapter: 4, isPreloaded: true),
      Word(name: 'widely', meaning: '널리', chapter: 4, isPreloaded: true),
      Word(name: 'externally', meaning: '외부에서', chapter: 4, isPreloaded: true),

      //chapter 5
      Word(name: 'sophisticated', meaning: '정교한', chapter: 5, isPreloaded: true),
      Word(name: 'timely', meaning: '시기적절한', chapter: 5, isPreloaded: true),
      Word(name: 'realistically', meaning: '현실적으로', chapter: 5, isPreloaded: true),
      Word(name: 'promptly', meaning: '즉시', chapter: 5, isPreloaded: true),
      Word(name: 'accessible', meaning: '출입할 수 있는', chapter: 5, isPreloaded: true),
      Word(name: 'implement', meaning: '실시하다', chapter: 5, isPreloaded: true),
      Word(name: 'feedback', meaning: '의견', chapter: 5, isPreloaded: true),
      Word(name: 'outstanding', meaning: '우수한', chapter: 5, isPreloaded: true),
      Word(name: 'inform', meaning: '~에게 알리다', chapter: 5, isPreloaded: true),
      Word(name: 'replacement', meaning: '교체', chapter: 5, isPreloaded: true),
      Word(name: 'announcement', meaning: '공고', chapter: 5, isPreloaded: true),
      Word(name: 'department', meaning: '부서', chapter: 5, isPreloaded: true),
      Word(name: 'permanently', meaning: '영구적으로', chapter: 5, isPreloaded: true),
      Word(name: 'fulfill', meaning: '만족시키다', chapter: 5, isPreloaded: true),
      Word(name: 'outline', meaning: '개요', chapter: 5, isPreloaded: true),
      Word(name: 'explain', meaning: '설명하다', chapter: 5, isPreloaded: true),
      Word(name: 'contain', meaning: '포함하다', chapter: 5, isPreloaded: true),
      Word(name: 'compile', meaning: '편집하다', chapter: 5, isPreloaded: true),
      Word(name: 'subsequent', meaning: '차후의', chapter: 5, isPreloaded: true),
      Word(name: 'overview', meaning: '개요', chapter: 5, isPreloaded: true),
      Word(name: 'provider', meaning: '공급자', chapter: 5, isPreloaded: true),
      Word(name: 'matter', meaning: '문제', chapter: 5, isPreloaded: true),
      Word(name: 'expertise', meaning: '전문 지식', chapter: 5, isPreloaded: true),
      Word(name: 'demonstrate', meaning: '증명하다', chapter: 5, isPreloaded: true),
      Word(name: 'remainder', meaning: '나머지', chapter: 5, isPreloaded: true),
      Word(name: 'essential', meaning: '필수적인', chapter: 5, isPreloaded: true),
      Word(name: 'divide', meaning: '분배하다', chapter: 5, isPreloaded: true),
      Word(name: 'major', meaning: '주요한', chapter: 5, isPreloaded: true),
      Word(name: 'compliance', meaning: '준수', chapter: 5, isPreloaded: true),
      Word(name: 'clarify', meaning: '명확하게 하다', chapter: 5, isPreloaded: true),
      Word(name: 'face', meaning: '직면하다', chapter: 5, isPreloaded: true),
      Word(name: 'follow', meaning: '~을 따라가다', chapter: 5, isPreloaded: true),
      Word(name: 'aspect', meaning: '관점', chapter: 5, isPreloaded: true),
      Word(name: 'apparently', meaning: '보기에 ~한 듯한', chapter: 5, isPreloaded: true),
      Word(name: 'aware', meaning: '알고 있는', chapter: 5, isPreloaded: true),
      Word(name: 'extended', meaning: '연장한', chapter: 5, isPreloaded: true),
      Word(name: 'accidentally', meaning: '뜻하지 않게', chapter: 5, isPreloaded: true),
      Word(name: 'advisable', meaning: '바람직한', chapter: 5, isPreloaded: true),
      Word(name: 'concerned', meaning: '염려하는', chapter: 5, isPreloaded: true),
      Word(name: 'speak', meaning: '이야기하다', chapter: 5, isPreloaded: true),

      //chapter 6
      Word(name: 'check in', meaning: '체크인하다', chapter: 6, isPreloaded: true),
      Word(name: 'compensate', meaning: '보상하다', chapter: 6, isPreloaded: true),
      Word(name: 'complimentary', meaning: '무료의', chapter: 6, isPreloaded: true),
      Word(name: 'chef', meaning: '주방장', chapter: 6, isPreloaded: true),
      Word(name: 'container', meaning: '용기', chapter: 6, isPreloaded: true),
      Word(name: 'elegant', meaning: '우아한', chapter: 6, isPreloaded: true),
      Word(name: 'flavor', meaning: '맛', chapter: 6, isPreloaded: true),
      Word(name: 'accommodate', meaning: '~을 수용하다', chapter: 6, isPreloaded: true),
      Word(name: 'available', meaning: '이용 가능한', chapter: 6, isPreloaded: true),
      Word(name: 'reception', meaning: '환영회', chapter: 6, isPreloaded: true),
      Word(name: 'in advance', meaning: '미리', chapter: 6, isPreloaded: true),
      Word(name: 'regreshments', meaning: '다과', chapter: 6, isPreloaded: true),
      Word(name: 'make', meaning: '~을 하다', chapter: 6, isPreloaded: true),
      Word(name: 'cater', meaning: '음식물을 공급하다', chapter: 6, isPreloaded: true),
      Word(name: 'reservation', meaning: '예약', chapter: 6, isPreloaded: true),
      Word(name: 'beverage', meaning: '음료', chapter: 6, isPreloaded: true),
      Word(name: 'confirm', meaning: '확인하다', chapter: 6, isPreloaded: true),
      Word(name: 'cancel', meaning: '취소하다', chapter: 6, isPreloaded: true),
      Word(name: 'rate', meaning: '요금', chapter: 6, isPreloaded: true),
      Word(name: 'conveniently', meaning: '편리하게', chapter: 6, isPreloaded: true),
      Word(name: 'decorate', meaning: '장식하다', chapter: 6, isPreloaded: true),
      Word(name: 'information', meaning: '정보', chapter: 6, isPreloaded: true),
      Word(name: 'retain', meaning: '유지하다', chapter: 6, isPreloaded: true),
      Word(name: 'atmosphere', meaning: '분위기', chapter: 6, isPreloaded: true),
      Word(name: 'cuisine', meaning: '요리', chapter: 6, isPreloaded: true),
      Word(name: 'sequence', meaning: '순서', chapter: 6, isPreloaded: true),
      Word(name: 'extensive', meaning: '광범위한', chapter: 6, isPreloaded: true),
      Word(name: 'prior', meaning: '전의', chapter: 6, isPreloaded: true),
      Word(name: 'book', meaning: '예약하다', chapter: 6, isPreloaded: true),
      Word(name: 'amenity', meaning: '편의 시설', chapter: 6, isPreloaded: true),
      Word(name: 'belongings', meaning: '소지품', chapter: 6, isPreloaded: true),
      Word(name: 'entirely', meaning: '완전히', chapter: 6, isPreloaded: true),
      Word(name: 'ease', meaning: '완화시키다', chapter: 6, isPreloaded: true),
      Word(name: 'ingredient', meaning: '재료', chapter: 6, isPreloaded: true),
      Word(name: 'sip', meaning: '음미하며 마시다', chapter: 6, isPreloaded: true),
      Word(name: 'stir', meaning: '휘젓다', chapter: 6, isPreloaded: true),
      Word(name: 'choice', meaning: '선택물', chapter: 6, isPreloaded: true),
      Word(name: 'complication', meaning: '복잡한 문제', chapter: 6, isPreloaded: true),
      Word(name: 'freshness', meaning: '신선함', chapter: 6, isPreloaded: true),
      Word(name: 'occupancy', meaning: '이용률', chapter: 6, isPreloaded: true),
      Word(name: 'spot', meaning: '발견하다', chapter: 6, isPreloaded: true),

      //chapter 7
      Word(name: 'decline', meaning: '감소', chapter: 7, isPreloaded: true),
      Word(name: 'markedly', meaning: '현저하게', chapter: 7, isPreloaded: true),
      Word(name: 'increase', meaning: '인상', chapter: 7, isPreloaded: true),
      Word(name: 'revenue', meaning: '수입', chapter: 7, isPreloaded: true),
      Word(name: 'projection', meaning: '예상', chapter: 7, isPreloaded: true),
      Word(name: 'substantial', meaning: '상당한', chapter: 7, isPreloaded: true),
      Word(name: 'anticipate', meaning: '예상하다', chapter: 7, isPreloaded: true),
      Word(name: 'significantly', meaning: '상당히', chapter: 7, isPreloaded: true),
      Word(name: 'estimate', meaning: '추정하다', chapter: 7, isPreloaded: true),
      Word(name: 'shift', meaning: '옮기다', chapter: 7, isPreloaded: true),
      Word(name: 'fee', meaning: '요금', chapter: 7, isPreloaded: true),
      Word(name: 'production', meaning: '생산량', chapter: 7, isPreloaded: true),
      Word(name: 'sale', meaning: '매출액', chapter: 7, isPreloaded: true),
      Word(name: 'impressive', meaning: '굉장한', chapter: 7, isPreloaded: true),
      Word(name: 'representative', meaning: '직원', chapter: 7, isPreloaded: true),
      Word(name: 'recent', meaning: '최근의', chapter: 7, isPreloaded: true),
      Word(name: 'exceed', meaning: '~을 초과하다', chapter: 7, isPreloaded: true),
      Word(name: 'improvement', meaning: '향상', chapter: 7, isPreloaded: true),
      Word(name: 'employer', meaning: '고용주', chapter: 7, isPreloaded: true),
      Word(name: 'regular', meaning: '정기적인', chapter: 7, isPreloaded: true),
      Word(name: 'summarize', meaning: '요약하다', chapter: 7, isPreloaded: true),
      Word(name: 'typically', meaning: '보통', chapter: 7, isPreloaded: true),
      Word(name: 'whole', meaning: '전체의', chapter: 7, isPreloaded: true),
      Word(name: 'growth', meaning: '성장', chapter: 7, isPreloaded: true),
      Word(name: 'figure', meaning: '총액', chapter: 7, isPreloaded: true),
      Word(name: 'steady', meaning: '꾸준한', chapter: 7, isPreloaded: true),
      Word(name: 'frequent', meaning: '빈번한', chapter: 7, isPreloaded: true),
      Word(name: 'achieve', meaning: '달성하다', chapter: 7, isPreloaded: true),
      Word(name: 'assumption', meaning: '추정', chapter: 7, isPreloaded: true),
      Word(name: 'share', meaning: '공유하다', chapter: 7, isPreloaded: true),
      Word(name: 'encouraging', meaning: '고무적인', chapter: 7, isPreloaded: true),
      Word(name: 'incur', meaning: '입다', chapter: 7, isPreloaded: true),
      Word(name: 'slightly', meaning: '약간', chapter: 7, isPreloaded: true),
      Word(name: 'profit', meaning: '수익', chapter: 7, isPreloaded: true),
      Word(name: 'reliant', meaning: '의존하는', chapter: 7, isPreloaded: true),
      Word(name: 'illustrate', meaning: '분명히 보여주다', chapter: 7, isPreloaded: true),
      Word(name: 'inaccurate', meaning: '부정확한', chapter: 7, isPreloaded: true),
      Word(name: 'percentage', meaning: '비율', chapter: 7, isPreloaded: true),
      Word(name: 'reduce', meaning: '줄이다', chapter: 7, isPreloaded: true),
      Word(name: 'tend', meaning: '~하는 경향이 있다', chapter: 7, isPreloaded: true),
      Word(name: 'beyond', meaning: '~을 넘어서', chapter: 7, isPreloaded: true),

      //chapter 8
      Word(name: 'audit', meaning: '회계 감사', chapter: 8, isPreloaded: true),
      Word(name: 'accounting', meaning: '회계', chapter: 8, isPreloaded: true),
      Word(name: 'budget', meaning: '예산', chapter: 8, isPreloaded: true),
      Word(name: 'financial', meaning: '재정의', chapter: 8, isPreloaded: true),
      Word(name: 'curtail', meaning: '~을 줄이다', chapter: 8, isPreloaded: true),
      Word(name: 'deficit', meaning: '적자', chapter: 8, isPreloaded: true),
      Word(name: 'recently', meaning: '최근의', chapter: 8, isPreloaded: true),
      Word(name: 'substantially', meaning: '크게', chapter: 8, isPreloaded: true),
      Word(name: 'committee', meaning: '위원회', chapter: 8, isPreloaded: true),
      Word(name: 'frequently', meaning: '자주', chapter: 8, isPreloaded: true),
      Word(name: 'capability', meaning: '능력', chapter: 8, isPreloaded: true),
      Word(name: 'proceeds', meaning: '수익금', chapter: 8, isPreloaded: true),
      Word(name: 'reimburse', meaning: '변제하다', chapter: 8, isPreloaded: true),
      Word(name: 'considerably', meaning: '상당히', chapter: 8, isPreloaded: true),
      Word(name: 'adequate', meaning: '충분한', chapter: 8, isPreloaded: true),
      Word(name: 'total', meaning: '총계의', chapter: 8, isPreloaded: true),
      Word(name: 'allocate', meaning: '할당하다', chapter: 8, isPreloaded: true),
      Word(name: 'inspector', meaning: '조사관', chapter: 8, isPreloaded: true),
      Word(name: 'preferred', meaning: '선호되는', chapter: 8, isPreloaded: true),
      Word(name: 'quarter', meaning: '사분기', chapter: 8, isPreloaded: true),
      Word(name: 'interrupt', meaning: '중단시키다', chapter: 8, isPreloaded: true),
      Word(name: 'browse', meaning: '훑어보다', chapter: 8, isPreloaded: true),
      Word(name: 'prompt', meaning: '즉각적인', chapter: 8, isPreloaded: true),
      Word(name: 'deduct', meaning: '공제하다', chapter: 8, isPreloaded: true),
      Word(name: 'measurement', meaning: '측정', chapter: 8, isPreloaded: true),
      Word(name: 'shorten', meaning: '단축하다', chapter: 8, isPreloaded: true),
      Word(name: 'amend', meaning: '수정하다', chapter: 8, isPreloaded: true),
      Word(name: 'calculate', meaning: '계산하다', chapter: 8, isPreloaded: true),
      Word(name: 'exempt', meaning: '면제된', chapter: 8, isPreloaded: true),
      Word(name: 'deficient', meaning: '부족한', chapter: 8, isPreloaded: true),
      Word(name: 'compare', meaning: '비교하다', chapter: 8, isPreloaded: true),
      Word(name: 'fortunate', meaning: '운 좋은', chapter: 8, isPreloaded: true),
      Word(name: 'expenditure', meaning: '지출', chapter: 8, isPreloaded: true),
      Word(name: 'accurately', meaning: '정확하게', chapter: 8, isPreloaded: true),
      Word(name: 'worth', meaning: '~의 가치가 있는', chapter: 8, isPreloaded: true),
      Word(name: 'excess', meaning: '초과', chapter: 8, isPreloaded: true),
      Word(name: 'fiscal', meaning: '회계의', chapter: 8, isPreloaded: true),
      Word(name: 'incidental', meaning: '부수적인', chapter: 8, isPreloaded: true),
      Word(name: 'inflation', meaning: '물가 상승', chapter: 8, isPreloaded: true),
      Word(name: 'liable', meaning: '책임져야 할', chapter: 8, isPreloaded: true),
      Word(name: 'spend', meaning: '~을 쓰다', chapter: 8, isPreloaded: true),
      Word(name: 'turnover', meaning: '총 매상고', chapter: 8, isPreloaded: true),

      //chapter 9
      Word(name: 'announce', meaning: '발표하다', chapter: 9, isPreloaded: true),
      Word(name: 'interested', meaning: '관련 있는', chapter: 9, isPreloaded: true),
      Word(name: 'active', meaning: '적극적인', chapter: 9, isPreloaded: true),
      Word(name: 'accept', meaning: '수락하다', chapter: 9, isPreloaded: true),
      Word(name: 'foresee', meaning: '예견하다', chapter: 9, isPreloaded: true),
      Word(name: 'expansion', meaning: '확장', chapter: 9, isPreloaded: true),
      Word(name: 'relocate', meaning: '이전하다', chapter: 9, isPreloaded: true),
      Word(name: 'competitor', meaning: '경쟁업체', chapter: 9, isPreloaded: true),
      Word(name: 'asset', meaning: '자산', chapter: 9, isPreloaded: true),
      Word(name: 'contribute', meaning: '기여하다', chapter: 9, isPreloaded: true),
      Word(name: 'dedicated', meaning: '전념하는', chapter: 9, isPreloaded: true),
      Word(name: 'misplace', meaning: '잃어버리다', chapter: 9, isPreloaded: true),
      Word(name: 'considerable', meaning: '상당한', chapter: 9, isPreloaded: true),
      Word(name: 'last', meaning: '지속되다', chapter: 9, isPreloaded: true),
      Word(name: 'emerge', meaning: '부상하다', chapter: 9, isPreloaded: true),
      Word(name: 'grow', meaning: '성장하다', chapter: 9, isPreloaded: true),
      Word(name: 'select', meaning: '선발하다', chapter: 9, isPreloaded: true),
      Word(name: 'merge', meaning: '합병하다', chapter: 9, isPreloaded: true),
      Word(name: 'imply', meaning: '암시하다', chapter: 9, isPreloaded: true),
      Word(name: 'vital', meaning: '필수적인', chapter: 9, isPreloaded: true),
      Word(name: 'persist', meaning: '계속하다', chapter: 9, isPreloaded: true),
      Word(name: 'independent', meaning: '독립적인', chapter: 9, isPreloaded: true),
      Word(name: 'force', meaning: '세력', chapter: 9, isPreloaded: true),
      Word(name: 'establish', meaning: '설립하다', chapter: 9, isPreloaded: true),
      Word(name: 'initiate', meaning: '착수하다', chapter: 9, isPreloaded: true),
      Word(name: 'enhance', meaning: '향상시키다', chapter: 9, isPreloaded: true),
      Word(name: 'renowned', meaning: '저명한', chapter: 9, isPreloaded: true),
      Word(name: 'informed', meaning: '정보에 근거한', chapter: 9, isPreloaded: true),
      Word(name: 'minutes', meaning: '회의록', chapter: 9, isPreloaded: true),
      Word(name: 'waive', meaning: '적용하지 않다', chapter: 9, isPreloaded: true),
      Word(name: 'reach', meaning: '~에 달하다', chapter: 9, isPreloaded: true),
      Word(name: 'authority', meaning: '권한', chapter: 9, isPreloaded: true),
      Word(name: 'acquire', meaning: '매입하다', chapter: 9, isPreloaded: true),
      Word(name: 'surpass', meaning: '~을 능가하다', chapter: 9, isPreloaded: true),
      Word(name: 'run', meaning: '~을 운영하다', chapter: 9, isPreloaded: true),
      Word(name: 'improbable', meaning: '사실이라고 생각할 수 없는', chapter: 9, isPreloaded: true),
      Word(name: 'edge', meaning: '우위', chapter: 9, isPreloaded: true),
      Word(name: 'simultaneously', meaning: '동시의', chapter: 9, isPreloaded: true),
      Word(name: 'reveal', meaning: '밝히다', chapter: 9, isPreloaded: true),
      Word(name: 'productivity', meaning: '생산성', chapter: 9, isPreloaded: true),
      Word(name: 'uncertain', meaning: '확신이 없는', chapter: 9, isPreloaded: true),
      Word(name: 'premier', meaning: '으뜸의', chapter: 9, isPreloaded: true),

      //chapter 10
      Word(name: 'agenda', meaning: '의제', chapter: 10, isPreloaded: true),
      Word(name: 'convene', meaning: '모이다', chapter: 10, isPreloaded: true),
      Word(name: 'refute', meaning: '부인하다', chapter: 10, isPreloaded: true),
      Word(name: 'coordination', meaning: '조정', chapter: 10, isPreloaded: true),
      Word(name: 'unanimous', meaning: '만장일치의', chapter: 10, isPreloaded: true),
      Word(name: 'convince', meaning: '납득시키다', chapter: 10, isPreloaded: true),
      Word(name: 'consensus', meaning: '여론', chapter: 10, isPreloaded: true),
      Word(name: 'defer', meaning: '연기하다', chapter: 10, isPreloaded: true),
      Word(name: 'usually', meaning: '보통', chapter: 10, isPreloaded: true),
      Word(name: 'reschedule', meaning: '일정을 바꾸다', chapter: 10, isPreloaded: true),
      Word(name: 'meeting', meaning: '회의', chapter: 10, isPreloaded: true),
      Word(name: 'determine', meaning: '알아내다', chapter: 10, isPreloaded: true),
      Word(name: 'report', meaning: '보고하다', chapter: 10, isPreloaded: true),
      Word(name: 'comment', meaning: '논평하다', chapter: 10, isPreloaded: true),
      Word(name: 'phase', meaning: '단계', chapter: 10, isPreloaded: true),
      Word(name: 'approve', meaning: '승인하다', chapter: 10, isPreloaded: true),
      Word(name: 'enclosed', meaning: '동봉된', chapter: 10, isPreloaded: true),
      Word(name: 'easy', meaning: '쉬운', chapter: 10, isPreloaded: true),
      Word(name: 'record', meaning: '기록', chapter: 10, isPreloaded: true),
      Word(name: 'syggestion', meaning: '제안', chapter: 10, isPreloaded: true),
      Word(name: 'attention', meaning: '주의', chapter: 10, isPreloaded: true),
      Word(name: 'object', meaning: '반대하다', chapter: 10, isPreloaded: true),
      Word(name: 'coincidentally', meaning: '우연히', chapter: 10, isPreloaded: true),
      Word(name: 'crowded', meaning: '붐비는', chapter: 10, isPreloaded: true),
      Word(name: 'undergo', meaning: '겪다', chapter: 10, isPreloaded: true),
      Word(name: 'outcome', meaning: '결과', chapter: 10, isPreloaded: true),
      Word(name: 'narrowly', meaning: '주의 깊게', chapter: 10, isPreloaded: true),
      Word(name: 'differ', meaning: '의견을 달리하다', chapter: 10, isPreloaded: true),
      Word(name: 'discuss', meaning: '논의하다', chapter: 10, isPreloaded: true),
      Word(name: 'give', meaning: '하다', chapter: 10, isPreloaded: true),
      Word(name: 'brief', meaning: '~에게 간단히 설명하다', chapter: 10, isPreloaded: true),
      Word(name: 'distract', meaning: '산만하게 하다', chapter: 10, isPreloaded: true),
      Word(name: 'emphasis', meaning: '강조', chapter: 10, isPreloaded: true),
      Word(name: 'press', meaning: '언론', chapter: 10, isPreloaded: true),
      Word(name: 'organize', meaning: '준비하다', chapter: 10, isPreloaded: true),
      Word(name: 'mention', meaning: '언급하다', chapter: 10, isPreloaded: true),
      Word(name: 'persuasive', meaning: '설득력 있는', chapter: 10, isPreloaded: true),
      Word(name: 'understanding', meaning: '이해심 있는', chapter: 10, isPreloaded: true),
      Word(name: 'adjourn', meaning: '휴회하다', chapter: 10, isPreloaded: true),
      Word(name: 'constructive', meaning: '건설적인', chapter: 10, isPreloaded: true),
      Word(name: 'preside', meaning: '사회를 보다', chapter: 10, isPreloaded: true),
      Word(name: 'irrelevant', meaning: '관계가 없는', chapter: 10, isPreloaded: true),
      Word(name: 'constraint', meaning: '제한', chapter: 10, isPreloaded: true),
      Word(name: 'condensed', meaning: '요약한', chapter: 10, isPreloaded: true),
      Word(name: 'endorse', meaning: '지지하다', chapter: 10, isPreloaded: true),
      Word(name: 'punctually', meaning: '제시간에', chapter: 10, isPreloaded: true),

      // 필요한 다른 단어들도 추가
    ];

    for (var word in preloadedWords) {
      await db.insert(
        'words',
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<bool> insertWord(Word word) async {
    final db = await database;
    try {
      int id = await db.insert(
        'words',
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // 중복 시 무시
      );
      if (id == 0) {
        // 삽입이 무시된 경우 (이미 존재)
        return false;
      }
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<List<Word>> selectWords({int? chapter}) async {
    final db = await database;
    List<Map<String, dynamic>> data;
    if (chapter != null) {
      data = await db.query(
        'words',
        where: 'chapter = ?',
        whereArgs: [chapter],
      );
    } else {
      data = await db.query('words');
    }

    return List.generate(data.length, (i) {
      return Word.fromMap(data[i]);
    });
  }

  Future<Word> selectWord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> data =
    await db.query('words', where: "id = ?", whereArgs: [id]);
    return Word.fromMap(data[0]);
  }

  Future<bool> updateWord(Word word) async {
    final db = await database;
    try {
      await db.update(
        'words',
        word.toMap(),
        where: "id = ?",
        whereArgs: [word.id],
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> deleteWord(int id) async {
    final db = await database;
    try {
      await db.delete(
        'words',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // 추가된 메서드: selectWordsByChapters
  Future<List<Word>> selectWordsByChapters(List<int> chapters) async {
    final db = await database;
    // SQL 인젝션을 방지하기 위해 '?' 플레이스홀더를 사용합니다.
    final placeholders = List.filled(chapters.length, '?').join(',');
    final List<Map<String, dynamic>> data = await db.rawQuery(
      'SELECT * FROM words WHERE chapter IN ($placeholders)',
      chapters,
    );

    // remember > 0인 단어는 필터링하고 remember 카운터를 -1 감소시킵니다.
    List<Word> filteredWords = [];
    for (var row in data) {
      Word word = Word.fromMap(row);
      if (word.remember > 0) {
        word.remember -= 1;
        await updateWord(word);
      } else {
        filteredWords.add(word);
      }
    }

    return filteredWords;
  }
}