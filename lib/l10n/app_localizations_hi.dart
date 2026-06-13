// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'रिफ्लेक्सिव एजेंट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get general => 'सामान्य';

  @override
  String get prompts => 'प्रॉम्ट्स';

  @override
  String iteration(int count) {
    return 'पुनरावृत्ति: $count';
  }

  @override
  String remaining(int seconds) {
    return 'शेष: $seconds सेकंड';
  }

  @override
  String get critic => 'समीक्षक:';

  @override
  String get generatorDraft => 'जेनरेटर (ड्राफ्ट):';

  @override
  String get stoppingCriteria => 'रोकने के मानदंड';

  @override
  String get maxDuration => 'अधिकतम अवधि (सेकंड)';

  @override
  String get maxIterations => 'अधिकतम पुनरावृत्तियाँ';

  @override
  String get requestDelay => 'अनुरोध विलंब (ms)';

  @override
  String get requestDelaySubtitle =>
      'दर सीमाओं से बचने के लिए API कॉल के बीच विलंब';

  @override
  String get stopIfNoIssues => 'यदि कोई समस्या न हो तो रुकें';

  @override
  String get stopIfNoIssuesSubtitle =>
      'यदि समीक्षक को कोई दोष नहीं मिलता है तो जल्दी बाहर निकलें';

  @override
  String get reflectionStrategy => 'चिंतन रणनीति';

  @override
  String get llmConfiguration => 'LLM कॉन्फ़िगरेशन';

  @override
  String get provider => 'प्रदाता';

  @override
  String get apiKey => 'API कुंजी';

  @override
  String get baseUrl => 'बेस URL';

  @override
  String get modelName => 'मॉडल का नाम';

  @override
  String get modelNameHelper =>
      'प्रदाता द्वारा अनुशंसित मॉडल का उपयोग करने के लिए \"auto\" या \"default\" टाइप करें';

  @override
  String get resetToDefault => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get resetToProviderDefault => 'प्रदाता डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get systemArchitecture => 'सिस्टम आर्किटेक्चर';

  @override
  String get systemArchitectureHelper => 'एजेंट के लिए सामान्य निर्देश';

  @override
  String get mathFormatting => 'गणित स्वरूपण';

  @override
  String get mathFormattingHelper => 'LaTeX आउटपुट के लिए निर्देश';

  @override
  String get generatorRole => 'जेनरेटर भूमिका';

  @override
  String get generatorRoleHelper => 'पहला ड्राफ्ट बनाने के लिए प्रॉम्ट';

  @override
  String get criticRole => 'समीक्षक भूमिका (मानक)';

  @override
  String get criticRoleHelper => 'मानक स्व-समीक्षा के लिए प्रॉम्ट';

  @override
  String get devilsAdvocateRole => 'डेविल्स एडवोकेट भूमिका';

  @override
  String get devilsAdvocateRoleHelper => 'आक्रामक आलोचना के लिए प्रॉम्ट';

  @override
  String get editorRole => 'संपादक भूमिका';

  @override
  String get editorRoleHelper => 'अंतिम पॉलिशिंग चरण के लिए प्रॉम्ट';

  @override
  String get exportPrompts => 'प्रॉम्प्ट निर्यात करें';

  @override
  String get importPrompts => 'प्रॉम्प्ट आयात करें';

  @override
  String get exportSuccess => 'प्रॉम्प्ट क्लिपबोर्ड पर निर्यात किए गए';

  @override
  String get importSuccess => 'प्रॉम्प्ट सफलतापूर्वक आयात किए गए';

  @override
  String get importError => 'प्रॉम्प्ट आयात करने में विफल: अमान्य प्रारूप';

  @override
  String get useInternet => 'इंटरनेट खोज सक्षम करें';

  @override
  String get useInternetSubtitle =>
      'मॉडल को अद्यतित जानकारी के लिए वेब तक पहुँचने की अनुमति दें (यदि प्रदाता द्वारा समर्थित हो)';
}
