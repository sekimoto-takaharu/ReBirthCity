import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/social_tourism/domain/models/service_link.dart';
import 'package:rebirth_city/features/social_tourism/domain/models/tour_city.dart';

final tourCitiesProvider = Provider<List<TourCity>>((ref) {
  return const [
    TourCity(
      name: '未来の松本市',
      prefecture: '長野県',
      yearOffset: 30,
      summary: '城下町の歴史資産を活かし、相続相談と空き家再生を同時に進めた成功例。',
      happinessScore: 82.4,
      financialBalance: 79.6,
      highlight: '空き家活用率 68%',
    ),
    TourCity(
      name: '未来の別府市',
      prefecture: '大分県',
      yearOffset: 50,
      summary: '高齢者ケアと観光を接続し、街全体をウェルネス資産へ転換。',
      happinessScore: 85.1,
      financialBalance: 76.2,
      highlight: '健康投資参加者 2.4万人',
    ),
    TourCity(
      name: '未来の鎌倉市',
      prefecture: '神奈川県',
      yearOffset: 100,
      summary: '家族の記録アーカイブと地域基金で、継承インフラが定着した未来都市。',
      happinessScore: 89.0,
      financialBalance: 83.8,
      highlight: '継承資産スコア 94',
    ),
  ];
});

final serviceLinksProvider = Provider<List<ServiceLink>>((ref) {
  return const [
    ServiceLink(
      title: 'いい葬儀',
      description: '葬儀の比較・相談につながる代表サービス。',
      url: 'https://www.e-sogi.com/',
    ),
    ServiceLink(
      title: 'いいお墓',
      description: 'お墓・霊園選びの情報導線。',
      url: 'https://www.e-ohaka.com/',
    ),
    ServiceLink(
      title: 'いい相続',
      description: '相続相談・手続きの比較導線。',
      url: 'https://www.i-sozoku.com/',
    ),
    ServiceLink(
      title: '鎌倉新書 コーポレート',
      description: '事業全体と終活インフラ構想の確認先。',
      url: 'https://www.kamakura-net.co.jp/',
    ),
  ];
});
